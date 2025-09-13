# Dunder Mifflin Inventory Service

[![PROD Build Status](https://github.com/mel-cdn/aws-gcp-azure-terraform-fastapi/actions/workflows/deploy.yml/badge.svg?branch=main)](https://github.com/mel-cdn/aws-gcp-azure-terraform-fastapi/actions/workflows/deploy.yml)

## 📖 Overview

This repository is a sandbox project for experimenting with **Domain-Driven Design (DDD)** principles using a **FastAPI** application across multiple cloud platforms.

It comes with **Terraform** setups for **GCP**, **AWS**, and **Azure**, deployed through **GitHub Actions** pipelines.

It simulates managing paper product inventory, sales personnel, and sales transactions — inspired by *Dunder Mifflin*.
## ✨ Highlights

- ![FastAPI](https://img.shields.io/badge/FastAPI-009688?logo=fastapi&logoColor=white) Domain-Driven Design architecture
  with FastAPI
- ![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white) Containerization with Docker
- ☁️ **Multi-cloud deployment targets** ☁️
    - ![GCP](https://img.shields.io/badge/Google%20Cloud-4285F4?logo=googlecloud&logoColor=white) Google Cloud
      Platform (GCP)
    - ![AWS](https://img.shields.io/badge/AWS-FF9900?logo=amazon-aws&logoColor=white) Amazon Web Services (AWS)
    - ![Azure](https://img.shields.io/badge/Azure-0078D4?logo=microsoft-azure&logoColor=white) Microsoft Azure (Azure)
- ![Terraform](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=white) Infrastructure as Code via
  Terraform
- ![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?logo=githubactions&logoColor=white) Automated
  CI/CD using GitHub Actions (Terraform validation + deployment)

---

## 🚀 Getting Started

### Prerequisites

Ensure the following tools are installed:

- **Python**
    - [Python 3.12+](https://www.python.org/)
- **Google Cloud Platform (GCP)**
    - [Google Cloud Account](https://console.cloud.google.com/)
    - [gcloud CLI](https://cloud.google.com/sdk/docs/install/)
- **Amazon Web Services (AWS)**
    - [AWS Account](https://aws.amazon.com/)
    - [AWS CLI](https://aws.amazon.com/cli/)
- **Microsft Azure (Azure)**
    - [Azure Account](https://azure.microsoft.com/)
    - [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/?view=azure-cli-latest)
- **Docker**
    - [Docker Desktop or CLI](https://docs.docker.com/desktop/)
- **Terraform**
    - [Terraform CLI](https://developer.hashicorp.com/terraform/install)

---

### Installation

```bash
# Clone repository
git clone git@github.com:mel-cdn/aws-gcp-azure-terraform-fastapi.git
cd aws-gcp-azure-terraform-fastapi

# Install Pipenv
pip install pipenv==2025.0.4

# Activate Pipenv environment
pipenv shell

# Install dependencies
./run-pip-updates.sh

# Run locally
./run-local-service.sh
```

### Testing

```bash

# Run pytest with coverage
./run-unit-tests-with-coverage.sh
```

## 🌍 API Deployments

### Infrastructure as Code (IaC)

- [AWS via Terraform](infra/terraform/aws/README.md)
- [GCP via Terraform](infra/terraform/gcp/README.md)
- [Azure via Terraform](infra/terraform/azure/README.md)

### FastAPI Endpoints

#### AWS Swagger URL
  > Heads up — this service might be unavailable because I paused it to save on costs (since App Runner doesn’t support 0-minimum instance scaling, haha! 🙂)
- App Runner: https://xzmd8mftmp.ap-southeast-1.awsapprunner.com/swagger
- Domain Mapped: https://api.dminventory.aws.melcadano.com/swagger

#### GCP Swagger URL
- Cloud Run: https://dm-inventory-api-6jqimisapa-de.a.run.app/swagger
- Domain Mapped: https://api.dminventory.gcp.melcadano.com/swagger

#### Azure Swagger URL
- Container App: https://playground-dm-inventory-prod-aca.proudwave-14ef48de.southeastasia.azurecontainerapps.io/swagger
- Domain Mapped: https://api-dminventory-azure.melcadano.com/swagger
> Dashes, because Azure does not support multi-level sub-domain for binding_type = "SniEnabled" 🙂

## 🗺️ Roadmap / To-Do

### Inventory Service

- [X] Initial setup of FastAPI project
- [ ] Make `PaperProduct` a nested object of `Product`
- [ ] Add `Salesman` and `Sales` entities
- [ ] Integrate real database: S3 (AWS)
- [ ] Integrate real database: Cloud Storage (GCP)
- [ ] Integrate real database: Azure Storage (Azure)

### Infrastructure (GCP)

- [X] Terraform deployment with GCS backend
- [X] Setup GitHub Actions deployment pipeline
- [X] Automated deployment to `prod` environment
- [X] Map service to a domain name
- [ ] Update GitHub Pipeline to use OIDC instead of Service Account Key

### Infrastructure (AWS)

- [X] Terraform deployment with S3 backend
- [X] Setup GitHub Actions deployment pipeline
- [X] Automated deployment to `prod` environment
- [X] Map service to a domain name
- [ ] Update GitHub Pipeline to use OIDC instead AWS Keys

### Infrastructure (Azure)

- [X] Terraform deployment with backend
- [X] Setup GitHub Actions deployment pipeline
- [X] Automated deployment to `prod` environment
- [X] Map service to a domain name
