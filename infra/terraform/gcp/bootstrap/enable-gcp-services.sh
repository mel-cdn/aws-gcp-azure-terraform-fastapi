#!/usr/bin/env bash

set -e -u

# Run this with an authenticated account that has sufficient IAM privileges.
echo "> Enabling APIs..."
gcloud services enable artifactregistry.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable iam.googleapis.com
echo "> Done."
