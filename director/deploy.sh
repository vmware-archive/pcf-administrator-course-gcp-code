#!/bin/bash

set -ex

if [ -z "$project_id" ]; then
    echo "must set project_id before running $0"
    exit 1
fi

if [ -z "$env_name" ]; then
    echo "must set env_name before running $0"
    exit 1
fi

bosh2 create-env bosh-deployment/bosh.yml -n \
  -o bosh-deployment/gcp/cpi.yml \
  -o bosh-deployment/gcp/service-account.yml \
  -o cpi.yml \
  --state ./state.json \
  --vars-store ./creds.yml \
  -v director_name=bosh-1 \
  -v internal_cidr=10.0.1.0/24 \
  -v internal_gw=10.0.1.1 \
  -v internal_ip=10.0.1.6 \
  -v gcp_credentials_json="$(cat ./gcp_credentials.json)" \
  -v project_id=${project_id} \
  -v service_account="terraform-service-account@${project_id}.iam.gserviceaccount.com" \
  -v zone=us-central1-b \
  -v tags=[internal,no-ip] \
  -v network="${env_name}-pcf-network" \
  -v subnetwork="${env_name}-bosh-subnet"

