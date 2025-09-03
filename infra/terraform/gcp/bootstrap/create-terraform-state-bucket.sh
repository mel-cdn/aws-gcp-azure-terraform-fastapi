#!/usr/bin/env bash

set -e -u

# Run this with an authenticated GCP IAM account that has permissions to create Cloud Storage buckets
# Example usage:
#   ./create-terraform-state-bucket.sh <my-project-id> <bucket-name> <region>

echo "> Creating $2 bucket on $3 for project: $1"

PROJECT_ID="$1"
BUCKET_NAME="$2"
REGION="$3"

gcloud storage buckets create gs://"$BUCKET_NAME" \
  --project="$PROJECT_ID" \
  --location="$REGION" \
  --default-storage-class=STANDARD

echo "============================================="
echo "> Cloud Storage bucket: $BUCKET_NAME created."
