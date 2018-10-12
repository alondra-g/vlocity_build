#!/usr/bin/env bash 
set -e

./codeship/decryptFiles.sh

SF_AUTH_ORG=`sfdx force:auth:sfdxurl:store -f codeship/unencrypted_files/test.sfdx --json`
SF_USERNAME=`echo $SF_AUTH_ORG | jq -r '. | .result.username'`

npm run-script unitTest

npm link

vlocity -sfdx.username $SF_USERNAME runTestJob

# Must return a JSON with a result
vlocity -sfdx.username $SF_USERNAME runTestJob --json | jq .status