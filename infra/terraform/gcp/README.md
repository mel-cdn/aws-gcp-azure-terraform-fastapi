# Terraform Deployment

## Getting Started

### Prerequisites

Ensure you have the following:

- **Google Cloud Project**
    - [Google Cloud Account](https://console.cloud.google.com/)
    - Install [gcloud CLI](https://cloud.google.com/sdk/docs/install)
- **Terraform**
    - Install [Terraform CLI](https://developer.hashicorp.com/terraform/install)

### Authenticate Google Cloud Credentials

```bash

# Authenticate your GCP account
gcloud init

# Make sure you to set your default project
gcloud config set project <YOUR-GCP-ID>
Updated property [core/project].

# Set default app credentials for integrations e.g. SDK
gcloud auth application-default login
```

## Terraform Setup and Local Deployment
> Assuming that the authenticated account has the right privileges
1. Set working directory ```cd infra/terraform/gcp```
2. Open `variables.tf`.
3. Update `project_prefix` with your GCP's deployment values. This will be appended with `ENVIRONMENT` e.g. `my-project-prefix-dev`
4. Execute scripts below to start deployment.
```bash

# Set workspace; This will be used as ENVIRONMENT
terraform workspace select -or-create dev

# Initialize Terraform
terraform init --backend-config="<your-gcs-bucket-for-tf-state>"

# Format files
terraform fmt

# Validate files
terraform validate

# Plan deployment
terraform plan

# Apply, review changes then approve
terraform apply
```

## CI/CD Deployer Service Account Setup
> In this project, we use [GitHub Actions](https://github.com/features/actions). Refer to this [deployment template](../../../.github/workflows/gcp_deploy.yml).

Create a service account for CI/CD deployment and assign required roles.
> Assuming that the authenticated account has the right privileges
```bash

#!/usr/bin/env bash

set -e -u

PROJECT_ID="my-project-id"
SA_NAME="dm-terraform-deployer"
SA_DISPLAY_NAME="Dunder Mifflin Terraform Deployer"
DESCRIPTION="CI/CD Service Account for Terraform"
ROLES=(
  "roles/serviceusage.serviceUsageAdmin"  # Service Usage Admin for Google APIs management (enable/disable)
  "roles/storage.admin"                   # Storage Admin for Terraform backend GCS bucket
  "roles/run.admin"                       # Cloud Run Admin for Cloud Run Service deployments
  "roles/iam.serviceAccountAdmin"         # Service Account Admin for management for service API account (create/update)
  "roles/resourcemanager.projectIamAdmin" # Service Usage Admin for creating and assigning roles to service account
  "roles/artifactregistry.admin"          # Artifact Registry Administrator for managing Docker repositories/images management (create/delete)
)

# ROLES=("roles/owner") # Use this, if you don't mind giving super powers

# 1. Create service account
gcloud iam service-accounts create $SA_NAME \
  --project $PROJECT_ID \
  --display-name "$SA_DISPLAY_NAME" \
  --description "$DESCRIPTION"

SA_EMAIL="$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"

# 2. Assign roles
for ROLE in "${ROLES[@]}"; do
  echo "Assigning $ROLE to $SA_EMAIL"
  gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="$ROLE"
done

echo "Service account $SA_EMAIL created and roles assigned!"
```
