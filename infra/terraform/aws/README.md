# AWS Terraform Deployment

## Getting Started

### Prerequisites

Before proceeding, ensure the following are installed and configured:

- **Amazon Web Services (AWS)**
    - [Create an AWS Account](https://aws.amazon.com/)
    - Install the [AWS CLI](https://aws.amazon.com/cli/)
- **Terraform**
    - Install the [Terraform CLI](https://developer.hashicorp.com/terraform/install)

### Authenticate AWS Credentials

```bash
# Configure AWS credentials (Access Key / Secret Key or SSO)
aws configure

# Alternatively, for multiple profiles
aws configure --profile <PROFILE_NAME>
```

## Boostrap AWS Environment

> Run these with an AWS profile that has sufficient IAM privileges.

```bash
# Activate AWS profile
export AWS_PROFILE="<aws-profile>"

cd infra/terraform/aws

# Create a Terraform State bucket and Locks table
./bootstrap/create-terraform-state-resources.sh <resource-name> <region>
```

## Terraform Setup and Local Deployment

> Run these with an AWS profile that has sufficient IAM privileges.

1. Navigate to the Terraform directory:

```bash
cd infra/terraform/aws
```

2. Open `variables.tf` and update with your actual values. You may also
   use [.tfvars](https://developer.hashicorp.com/terraform/language/values/variables#assigning-values-to-root-module-variables).

3. Run the following commands to initialize and deploy:

```bash
# Activate AWS profile
export AWS_PROFILE="<aws-profile>"

# Initialize Terraform with your remote backend.
# Refer to ## Boostrap AWS Environment
terraform init \  
  --backend-config="bucket=<your-s3-bucket-for-tf-state>" \
  --backend-config="dynamodb_table=<your-dynamodb-table-for-tf-locks>"

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
Refer to the [deployment workflow template](../../../.github/workflows/deploy-aws.yml) for integration.

The following script creates a CI/CD service account and assigns the required roles.

```bash
# Activate AWS profile
export AWS_PROFILE="<aws-profile>"
./bootstrap/create-deployer-sa.sh <environment> <s3-terraform-state-bucket> <dynamodb-terraform-locks-table>
```

### GitHub Actions Setup

Once your service account has been created, follow these steps to integrate it with GitHub Actions:

1. Generate Access Keys

```bash
aws iam create-access-key --user-name <service-account-name>
```

2. Add Keys to GitHub Environment Secrets (environment-specific)
    - Navigate to your repository: → Settings → Secrets and variables → Actions → Manage environment secrets → Secrets →
      New environment
    - Create an environment (e.g., `dev`).
    - Add the following secrets with values from the previous step:
        - `AWS_ACCESS_KEY_ID`
        - `AWS_SECRET_ACCESS_KEY`
3. Add Repository Secrets (common across all environments)
    - Navigate to your repository: → Settings → Secrets and variables → Actions → Secrets → New repository secret
    - Add the following secrets:
        - `AWS_TERRAFORM_BACKEND_BUCKET`
        - `AWS_TERRAFORM_LOCK_TABLE`
3. Add Repository Variables (common across all environments)
    - Navigate to your repository: → Settings → Secrets and variables → Actions → Variables → New repository variable
    - Add the following variables:
        - `APP_NAME` = `dm-inventory`
        - `AWS_INFRA` = `playground`
        - `AWS_REGION` = `ap-southeast-1`
4. Update GitHub Actions Workflow
    - Ensure your workflow [deploy-aws template](../../../.github/workflows/deploy-aws.yml) references these secrets.
5. Trigger Deployment
    - Push changes to your target branch (e.g., `develop` or `main`).
    - GitHub Actions will automatically run the Terraform deployment workflow.
