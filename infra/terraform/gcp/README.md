# Terraform Deployment

## Getting Started

### Prerequisites

Before proceeding, ensure the following are installed and configured:

- **Google Cloud Project**
  - [Create a Google Cloud Account](https://console.cloud.google.com/)
  - Install the [gcloud CLI](https://cloud.google.com/sdk/docs/install)
- **Terraform**
  - Install the [Terraform CLI](https://developer.hashicorp.com/terraform/install)

### Authenticate Google Cloud Credentials

```bash

# Authenticate your GCP account
gcloud init

# Set your default project
gcloud config set project <YOUR-GCP-ID>

# Configure application default credentials (for SDKs and integrations)
gcloud auth application-default login
```

## Terraform Setup and Local Deployment
> The steps below assume the authenticated account has sufficient privileges.

1. Navigate to the Terraform directory:
```bash
cd infra/terraform/gcp
```
2. Open `variables.tf` and update the `project_prefix` variable with your GCP project’s deployment prefix.
   - This value will be appended with the `ENVIRONMENT`.
   - **Example**: If `ENVIRONMENT` = `dev`, and `project_prefix` = `my-project-prefix`, the final project ID will be `my-project-prefix-dev`.

3. Run the following commands to initialize and deploy:
```bash

# Select or create a Terraform workspace (this will act as the ENVIRONMENT)
terraform workspace select -or-create dev

# Initialize Terraform with your remote backend
terraform init --backend-config="<your-gcs-bucket-for-tf-state>"

# Format Terraform configuration files
terraform fmt

# Validate configuration
terraform validate

# Generate execution plan
terraform plan

# Apply changes (review plan before approving)
terraform apply
```

## CI/CD Deployer Service Account Setup
This project uses [GitHub Actions](https://github.com/features/actions) for CI/CD.
Refer to the [deployment workflow template](../../../.github/workflows/gcp_deploy.yml) for integration.

### Create a Service Account
The following script creates a CI/CD service account and assigns the required roles.
> Run this with an authenticated account that has sufficient IAM privileges.
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
### GitHub Actions Setup

Once your service account has been created, complete the following steps to integrate it with GitHub Actions:
1. Generate Service Account Key
```bash

gcloud iam service-accounts keys create key.json \
  --iam-account=$SA_EMAIL \
  --project=$PROJECT_ID
```
2. Add Key to GitHub Secrets

- Go to your repository → Settings → Secrets and variables → Actions → New repository secret
- Add the following:
  - `GCP_PREFIX` → your project ID prefix
  - `GCP_SA_KEY` → contents of the `key.json` file (copy and paste)
3. Update GitHub Actions Workflow
   - Ensure the workflow [gcp_deploy template](../../../.github/workflows/gcp_deploy.yml) references the secrets.
4. Trigger Deployment
- Push changes to the default branch (e.g., develop or main)
- GitHub Actions will automatically run the Terraform deployment workflow.
