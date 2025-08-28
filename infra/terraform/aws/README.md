# Terraform Deployment (AWS)

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
### Create a Terraform State Bucket
```bash
# Run these with an authenticated account that has sufficient IAM privileges.
cd infra/terraform/aws
./bootstrap/create-terraform-state-bucket.sh <bucket-name> <region>
```

## Terraform Setup and Local Deployment
> The steps below assume the authenticated account has sufficient privileges.

1. Navigate to the Terraform directory:
```bash
cd infra/terraform/aws
```
2. Open `variables.tf` and update as needed.
> You may also use [.tfvars](https://developer.hashicorp.com/terraform/language/values/variables#assigning-values-to-root-module-variables).

3. Run the following commands to initialize and deploy:
```bash

# Select or create a Terraform workspace (this will act as the ENVIRONMENT)
terraform workspace select -or-create dev

# Initialize Terraform with your remote backend
terraform init --backend-config="<your-s3-bucket-for-tf-state>"

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
