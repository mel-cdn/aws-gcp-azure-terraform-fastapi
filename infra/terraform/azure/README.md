# Terraform Deployment (Azure)

## Getting Started

### Prerequisites

Before proceeding, ensure the following are installed and configured:

- **Microsoft Azure**
  - [Azure Account](https://azure.microsoft.com/)  
  - Install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)  
- **Terraform**
  - Install the [Terraform CLI](https://developer.hashicorp.com/terraform/install)

### Authenticate Azure Credentials

```bash
# Login to Azure
az login

# Set the active subscription (if multiple are available)
az account set --subscription <SUBSCRIPTION_ID>

# Verify login
az account show
```

## Bootstrap Azure Environment
> The steps below assume the authenticated account has sufficient privileges (e.g., Owner or Contributor on the subscription).

1. Create a Resource Group for the project:
```bash
# For Terraform Backend (e.g. playground-tf-state-rg)
az group create --name "<infra>-tf-state-rg" --location <location>
```
2. Create a Storage Account for Terraform state:
```bash
cd infra/terraform/azure

# Create a Terraform State Storage Account and Container
./bootstrap/create-terraform-state-resources.sh <resource-group> <storage-account-name> <location>
```

## Terraform Setup and Local Deployment
> The steps below assume the authenticated account has sufficient privileges (e.g., Owner or Contributor on the subscription).

1. Navigate to the Terraform directory:

```bash
cd infra/terraform/azure
```

2. Open `variables.tf` and update with your actual values. You may also
   use [.tfvars](https://developer.hashicorp.com/terraform/language/values/variables#assigning-values-to-root-module-variables).
3. Run the following commands to initialize and deploy:

```bash
# Initialize Terraform with your remote backend.
# Refer to ## Boostrap Azure Environment
terraform init \  
  --backend-config="resource_group_name=<resource-group-name>" \
  --backend-config="storage_account_name=<storage-account-name>" \
  --backend-config="container_name=<container-name>" \
  --backend-config="key=<app-name>.tfstate"

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
Refer to the [deployment workflow template](../../../.github/workflows/deploy-azure.yml) for integration.

The following script creates a CI/CD service account and assigns the required roles.
```bash
# Create Azure Service Principal
az ad sp create-for-rbac \
  --name dm-tf-deployer-sa \
  --role "User Access Administrator" \
  --scopes /subscriptions/<SUBSCRIPTION_ID> \
  --sdk-auth

# Save the JSON output for next steps
```

### GitHub Actions Setup

Once your service account has been created, follow these steps to integrate it with GitHub Actions:

1. Add Repository Secrets (common across all environments)
    - Navigate to your repository: → Settings → Secrets and variables → Actions → Secrets → New repository secret
    - Add the following secrets:
        - `AZURE_CREDENTIALS` → JSON output from the previous step
        - `AZURE_TF_STORAGE_ACCOUNT` → result from [bootstrap step](#bootstrap-azure-environment)
2. Add Repository Variables (common across all environments)
    - Navigate to your repository: → Settings → Secrets and variables → Actions → Variables → New repository variable
    - Add the following variables:
        - `APP_NAME` = `dm-inventory`
        - `AZURE_TF_RESOURCE_GROUP` → result from [bootstrap step](#bootstrap-azure-environment)
        - `AZURE_INFRA` = `playground`
        - `AZURE_LOCATION` = `southeastasia`
3. Update GitHub Actions Workflow
    - Ensure your workflow [deploy-azure template](../../../.github/workflows/deploy-azure.yml) references these secrets.
4. Trigger Deployment
    - Push changes to your target branch (e.g., `develop` or `main`).
    - GitHub Actions will automatically run the Terraform deployment workflow.
