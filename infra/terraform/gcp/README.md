# GCP Terraform Deployment

## Getting Started

### Prerequisites

Before proceeding, ensure the following are installed and configured:

- **Google Cloud Project**
    - Create a free [Google Cloud Account](https://console.cloud.google.com/)
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
>
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
    - **Example**: If `ENVIRONMENT` = `dev`, and `project_prefix` = `my-project-prefix`, the final project ID will be
      `my-project-prefix-dev`.
    - You may also use [.tfvars](https://developer.hashicorp.com/terraform/language/values/variables#assigning-values-to-root-module-variables).
3. Run the following commands to initialize and deploy:

```bash
# Initialize Terraform with your remote backend
# Refer to ## Boostrap GCP Environment
terraform init --backend-config="bucket=<your-gcs-bucket-for-tf-state>"

# Select or create a Terraform workspace (this will act as the ENVIRONMENT e.g. dev)
terraform workspace select -or-create <environment>

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
Refer to the [deployment workflow template](../../../.github/workflows/deploy-gcp.yml) for integration.

The following script creates a CI/CD service account and assigns the required roles.

```bash
./bootstrap/create-deployer-sa.sh <my-project-id>
```

### GitHub Actions Setup

Once your service account has been created, complete the following steps to integrate it with GitHub Actions:

1. Generate Service Account Key

```bash
gcloud iam service-accounts keys create key.json --iam-account=<service-account-email> --project=<my-project-id>
```

2. Add Keys to GitHub Environment Secrets (environment-specific)
    - Navigate to your repository: → Settings → Secrets and variables → Actions → Manage environment secrets → Secrets →
      New environment
    - Create an environment (e.g., `dev`).
    - Add the following secrets with values from the previous step:
        - `GCP_DEPLOYER_KEY` → contents of the `key.json` file (copy and paste)
3. Add Repository Secrets (common across all environments)
    - Navigate to your repository: → Settings → Secrets and variables → Actions → Secrets → New repository secret
    - Add the following secrets:  
        - `GCP_PREFIX` → your project ID prefix
        - `GCP_TERRAFORM_BACKEND_BUCKET_PREFIX`
3. Add Repository Variables (common across all environments)
    - Navigate to your repository: → Settings → Secrets and variables → Actions → Variables → New repository variable
    - Add the following variables:
        - `APP_NAME` = `dm-inventory`
        - `GCP_REGION` = `asia-east1`
        - `ROOT_DOMAIN_NAME` = `mydomain.com`
4. Update GitHub Actions Workflow
    - Ensure your workflow [deploy-gcp template](../../../.github/workflows/deploy-aws.yml) references these secrets.
5. Trigger Deployment
    - Push changes to your target branch (e.g., `develop` or `main`).
    - GitHub Actions will automatically run the Terraform deployment workflow.
