# GCP Terraform Deployment

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

## Boostrap GCP Environment
> The steps below assume the authenticated account has sufficient privileges.

```bash
cd infra/terraform/gcp

# Enable API Services
./bootstrap/enable-gcp-services.sh <my-project-id>

# Create a Terraform State Bucket
./bootstrap/create-terraform-state-bucket.sh <my-project-id> <bucket-name> <region>
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
    > You may also use [.tfvars](https://developer.hashicorp.com/terraform/language/values/variables#assigning-values-to-root-module-variables).
3. Run the following commands to initialize and deploy:
```bash
# Initialize Terraform with your remote backend
# Refer to ## Boostrap GCP Environment
terraform init --backend-config="bucket=<your-gcs-bucket-for-tf-state>"

# Select or create a Terraform workspace (this will act as the ENVIRONMENT e.g. dev)
terraform workspace select -or-create <environment>>

# Format Terraform configuration files
terraform fmt

# Validate configuration
terraform validate

# Generate execution plan
terraform plan

# Apply changes (review plan before approving)
terraform apply
```

## Setup CI/CD Deployment
### Create a Deployer Service Account

This project uses [GitHub Actions](https://github.com/features/actions) for CI/CD.
Refer to the [deployment workflow template](../../../.github/workflows/gcp_deploy.yml) for integration.

The following script creates a CI/CD service account and assigns the required roles.
```bash
# Run these with an authenticated account that has sufficient IAM privileges.
./bootstrap/create-deployer-sa.sh <my-project-id>
```

### GitHub Actions Setup
Once your service account has been created, complete the following steps to integrate it with GitHub Actions:
1. Generate Service Account Key
```bash
# Run these with an authenticated account that has sufficient IAM privileges.
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
