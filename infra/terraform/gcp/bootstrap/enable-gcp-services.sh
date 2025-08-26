#!/usr/bin/env bash

set -e -u

# Run this with an authenticated GCP IAM account that has permissions to enable services.
# Example usage:
#   ./enable-gcp-services.sh <project_id>

echo "> Enabling APIs for project: $1"

PROJECT_ID="$1"

gcloud services enable artifactregistry.googleapis.com --project="$PROJECT_ID"
gcloud services enable run.googleapis.com --project="$PROJECT_ID"
gcloud services enable iam.googleapis.com --project="$PROJECT_ID"

echo "> Done."
