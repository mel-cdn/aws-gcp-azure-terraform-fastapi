# Dunder Mifflin Inventory Service

[![PROD Build Status](https://github.com/mel-cdn/dm-inventory-service/actions/workflows/gcp_deploy.yml/badge.svg?branch=main)](https://github.com/mel-cdn/dm-inventory-service/actions/workflows/gcp_deploy.yml)

## Overview

This repository is a sandbox project for experimenting with **Domain-Driven Design (DDD)** principles using a **FastAPI
** application.  
It simulates managing paper product inventory, sales personnel, and sales transactions — inspired by *Dunder Mifflin*.

## Highlights

- Domain-Driven Design architecture with FastAPI
- Containerized with Docker
- Deployment targets:
  - Google Cloud Platform (GCP)
  - Amazon Web Services (AWS)
  - Microsoft Azure (Azure)
- Infrastructure as Code via Terraform
- Automated CI/CD using GitHub Actions with Terraform Validation and Deployment

---

## Getting Started

### Prerequisites

Ensure the following tools are installed:

- **Python**
    - [Python 3.12+](https://www.python.org/)
- **Google Cloud Platform (GCP)**
    - [Google Cloud Account](https://console.cloud.google.com/)
    - [cloud CLI](https://cloud.google.com/sdk/docs/install/)
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
git clone git@github.com:mel-cdn/dm-inventory-service.git
cd dm-inventory-service

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

## API Deployments

### Infrastructure as Code (IaC)

- [AWS via Terraform](infra/terraform/aws/README.md)
- [GCP via Terraform](infra/terraform/gcp/README.md)

### FastAPI Endpoints

- AWS - [not yet available](https://www.powerthesaurus.org/not_yet_available)
- GCP - [Swagger Docs](https://dm-inventory-api-6jqimisapa-de.a.run.app/swagger)

## Roadmap / To-Do

### Service

- [X] Initial setup of FastAPI project
- [ ] Make `PaperProduct` a nested object of `Product`
- [ ] Add `Salesman` and `Sales` entities
- [ ] Integrate real database: Cloud Storage (GCP)
- [ ] Integrate real database: S3 (AWS)

### Infrastructure (GCP)

- [X] Terraform deployment with GCS backend
- [X] Setup GitHub Actions deployment pipeline
- [X] Automated deployment to `prod` environment
- [ ] Update GitHub Pipeline to use OIDC instead of Service Account Key
- [ ] Map service to a domain name

### Infrastructure (AWS)

- [X] Terraform deployment with S3 backend
- [X] Setup GitHub Actions deployment pipeline
- [ ] Automated deployment to `prod` environment
- [ ] Update GitHub Pipeline to use OIDC instead AWS Keys
- [ ] Map service to a domain name

### Infrastructure (Azure)

- [ ] Terraform deployment with backend
- [ ] Setup GitHub Actions deployment pipeline
- [ ] Automated deployment to `prod` environment
- [ ] Map service to a domain name
