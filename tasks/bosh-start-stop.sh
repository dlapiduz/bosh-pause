#!/bin/bash
set -e

bosh-cli -e `cat om-bosh-creds/director_ip` \
    --ca-cert om-bosh-creds/bosh-ca.pem \
    alias-env om-bosh

BOSH_USERNAME=$(cat om-bosh-creds/bosh-username)
BOSH_PASSWORD=$(cat om-bosh-creds/bosh-pass)


echo "Logging in to BOSH..."
bosh-cli -e om-bosh log-in <<EOF 1>/dev/null
$BOSH_USERNAME
$BOSH_PASSWORD
EOF

echo "Getting Deployments"

deployments=$(bosh-cli --json -e om-bosh \
    deployments | jq -r ".Tables[0].Rows[][0]")

for dep in $deployments; do
  if [[ $dep != *"concourse"* ]]; then
    if [[ $command == "start" ]]; then
      bosh-cli -n -e om-bosh -d $dep start
    else
      bosh-cli -n -e om-bosh -d $dep stop
    fi
  fi
done
