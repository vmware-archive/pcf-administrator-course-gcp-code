#!/bin/bash -ex

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

function verify_checksum() {
  if [ ! "$(sha256sum $1 | cut -d' ' -f1)" == "$2" ]; then
    echo "Invalid checksum for $1"
    exit 1
  fi
}

function fetch_tile() {
  curl ${1} -Lvko ${2} \
      -H "Authorization: Token ${piv_net_token}"

  verify_checksum ${2} ${3}
}

echo "Fetching Elastic Runtime"
fetch_tile \
  https://network.pivotal.io/api/v2/products/elastic-runtime/releases/5106/product_files/18920/download \
  cf-1.10.6-build.1.pivotal \
  "30520637ca5963f8ce6e950c46ee44db09c78cfea674371e29dc5e68e51e2664"

echo "Fetching Pivotal MySql Tile"
fetch_tile \
  https://network.pivotal.io/api/v2/products/p-mysql/releases/5260/product_files/19506/download \
  p-mysql-1.9.2.pivotal \
  "9f6db6a3df98ddbf6ee14862702e25864fd012c7ec79b367bbb541db2a303dd1"

echo "Fetching JMX Bridge Tile"
fetch_tile \
  https://network.pivotal.io/api/v2/products/ops-metrics/releases/5425/product_files/20545/download \
  p-metrics-1.8.21.pivotal \
  "31d97654e0589528cf845bb3a4bc8f36220d0f837cc4c744bfa048e6e3f4d36d"


echo "Generating UAA Token"
uaa_token=$(curl -s -k -d 'grant_type=password' \
  -d "username=${ops_man_username}" \
  -d "password=${ops_man_password}" \
  -u 'opsman:' https://localhost/uaa/oauth/token |\
   jq .access_token |\
   tr -d '"')

function upload_tile() {
  curl https://localhost/api/v0/available_products -k -X POST \
    -F "product[file]=@${1}" \
    -H "Authorization: Bearer $uaa_token"
}

echo "Uploading Elastic Runtime to Ops Manager"
upload_tile cf-1.10.6-build.1.pivotal

echo "Uploading Pivotal MySql tile to Ops Manager"
upload_tile p-mysql-1.9.2.pivotal

echo "Uploading JMX Bridge Tile to Ops Manager"
upload_tile p-metrics-1.8.21.pivotal