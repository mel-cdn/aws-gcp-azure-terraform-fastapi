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
```
