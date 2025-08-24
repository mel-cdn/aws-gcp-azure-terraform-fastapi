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

## Terraform Setup and Local Deployment
> The steps below assume the authenticated account has sufficient privileges.

1. Navigate to the Terraform directory:
```bash
cd infra/terraform/aws
```
