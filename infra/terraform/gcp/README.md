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

### Terraform Setup and Local Deployment

```bash

# Initialize Terraform
terraform init

# Format files
terraform fmt

# Validate files
terraform validate

# Plan deployment
terraform plan -var "project_id=<YOUR-PROJECT-ID>"

# Apply deployment, review changes then approve
terraform apply -var "project_id=<YOUR-PROJECT-ID>"
```
