#!/bin/bash
set -e

bosh-cli -e `cat om-bosh-creds/director_ip` \
    --ca-cert om-bosh-creds/bosh-ca.pem \
    alias-env om-bosh

BOSH_USERNAME=$(cat om-bosh-creds/bosh-username)
BOSH_PASSWORD=$(cat om-bosh-creds/bosh-pass)

echo "Getting Deployments"

bosh-cli --json -e om-bosh \
    --client $BOSH_USERNAME \
    --client-secret $BOSH_PASSWORD \
    deployments | jq -r ".Tables[0].Rows[][0]"
