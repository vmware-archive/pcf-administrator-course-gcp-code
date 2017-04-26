#!/bin/bash

set -ex

if [ -z "$piv_net_token" ]; then
    echo "must set piv_net_token before running $0"
    exit 1
fi

if [ -z "$ops_man_username" ]; then
    echo "must set ops_man_username before running $0"
    exit 1
fi

if [ -z "$ops_man_password" ]; then
    echo "must set ops_man_password before running $0"
    exit 1
fi

if [ ! `which jq` ]; then sudo apt-get update && sudo apt-get install jq; fi;

echo "Fetching Elastic Runtime"
curl https://network.pivotal.io/api/v2/products/elastic-runtime/releases/5106/product_files/18920/download \
    -Lko 'cf-1.10.6-build.1.pivotal' \
    -H "Authorization: Token ${piv_net_token}"

echo "Generating UAA Token"
uaa_token=$(curl -s -k -d 'grant_type=password' \
    -d "username=${ops_man_username}" \
    -d "password=${ops_man_password}" \
    -u 'opsman:' https://localhost/uaa/oauth/token |\
     jq .access_token |\
     tr -d '"')
     
echo "Uploading Elastic Runtime to Ops Manager"
curl https://localhost/api/v0/available_products -k -X POST \
    -F 'product[file]=@cf-1.10.6-build.1.pivotal' \
    -H "Authorization: Bearer $uaa_token"
