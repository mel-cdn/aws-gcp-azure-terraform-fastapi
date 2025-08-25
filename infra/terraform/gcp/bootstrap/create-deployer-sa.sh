#!/usr/bin/env bash

set -e -u

# Run this with an authenticated account that has sufficient IAM privileges.

echo "> Creating SA for project: $1"

PROJECT_ID="$1"
SA_NAME="dm-terraform-deployer"
SA_DISPLAY_NAME="Dunder Mifflin Terraform Deployer"
DESCRIPTION="CI/CD Service Account for Terraform"
ROLES=(
  "roles/serviceusage.serviceUsageAdmin"  # Service Usage Admin: Google APIs management (enable/disable)
  "roles/storage.admin"                   # Storage Admin: Terraform backend GCS bucket
  "roles/run.admin"                       # Cloud Run Admin: Cloud Run Service deployments
  "roles/iam.serviceAccountUser"          # Service Account User: Deploying Cloud Run Service with Service Account
  "roles/iam.serviceAccountAdmin"         # Service Account Admin: Management for service API account (create/update)
  "roles/resourcemanager.projectIamAdmin" # Service Usage Admin: Creating and assigning roles to service account
  "roles/artifactregistry.admin"          # Artifact Registry Administrator: Managing Docker repositories/images management (create/delete)
)

# ROLES=("roles/owner") # Use this, if you don't mind giving super powers

# 1. Create service account
gcloud iam service-accounts create $SA_NAME \
  --project "$PROJECT_ID" \
  --display-name "$SA_DISPLAY_NAME" \
  --description "$DESCRIPTION"

SA_EMAIL="$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"

# 2. Assign roles
for ROLE in "${ROLES[@]}"; do
  echo "Assigning $ROLE to $SA_EMAIL"
  gcloud projects add-iam-policy-binding "$PROJECT_ID" \
    --member="serviceAccount:$SA_EMAIL" \
    --role="$ROLE"
done

echo "> Service account $SA_EMAIL created and roles assigned!"
