

set -e

direnv allow .
source .envrc

    gcloud org-policies reset constraints/compute.vmExternalIpAccess --project="$PROJECT_ID"
    gsutil mb "gs://$YOUR_TF_STATE_GCS_BUCKET_NAME/"
    gsutil versioning set on gs://$YOUR_TF_STATE_GCS_BUCKET_NAME/