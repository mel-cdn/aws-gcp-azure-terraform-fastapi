#!/usr/bin/env bash

set -e -u

# Run this with an authenticated GCP IAM account that has permissions to create Cloud Storage buckets
# Example usage:
#   ./create-terraform-state-bucket.sh <my-project-id> <bucket-name> <region>

PROJECT_ID="$1"
BUCKET_NAME="$2"
REGION="$3"

echo "> Creating $BUCKET_NAME Cloud Storage bucket on $REGION for project: $PROJECT_ID"

gcloud storage buckets create gs://"$BUCKET_NAME" \
  --project="$PROJECT_ID" \
  --location="$REGION" \
  --default-storage-class=STANDARD

echo "============================================="
echo "> Cloud Storage bucket: $BUCKET_NAME created."
