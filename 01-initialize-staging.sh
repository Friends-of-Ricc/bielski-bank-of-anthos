#!/bin/bash

set -e

direnv allow .
source .envrc


echo '🔑  Getting cluster credentials...'
gcloud container fleet memberships get-credentials staging-membership

echo '🙌  Deploying populate-db jobs for staging...'
skaffold config set default-repo "$REGION-docker.pkg.dev/$PROJECT_ID/bank-of-anthos"
skaffold run --profile=init-db-staging --module=accounts-db
skaffold run --profile=init-db-staging --module=ledger-db

echo '🕰  Wait for staging-db initialization to complete...'
kubectl wait --for=condition=complete job/populate-accounts-db job/populate-ledger-db -n bank-of-anthos-staging --timeout=300s