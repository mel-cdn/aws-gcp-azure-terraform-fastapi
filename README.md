# Dunder Mifflin Inventory Service

## Overview

This repository serves as a sandbox/playground for experimenting with a Domain-Driven Design (DDD) approach in a FastAPI
application. It focuses on managing paper product inventory, sales personnel, and sales transactions.

## Highlights (WIP)

- Domain-Driven Design using FastAPI
- Dockerized service
- Google Cloud Project (GCP) deployment
- Amazon Web Service (AWS) deployment
- Terraform with GitHub Actions deployment

## Getting Started

### Prerequisites

Ensure you have the following:

- **Python**
    - Install >= [Python 3.12](https://www.python.org/)
- **Google Cloud Project**
    - [Google Cloud Account](https://console.cloud.google.com/)
    - Install [gcloud CLI](https://cloud.google.com/sdk/docs/install)
- CircleCI
    - [CircleCI Account]((https://circleci.com/))
- **Terraform**
    - Install [Terraform CLI](https://developer.hashicorp.com/terraform/install)
- **Docker**
    - Install [Docker Desktop or CLI](https://docs.docker.com/desktop/)

### Installation

```bash

# Clone repository
git clone git@github.com:mel-cdn/pg-dm-inventory-service.git

# Install Pipenv
pip install pipenv==2025.0.4

# Activate Pipenv environment
pipenv shell

# Install dependencies
./run-pip-updates.sh

# Run locally
./run-local-service.sh
```

## Testing

```bash

# Run pytest tests
./run-unit-tests-with-coverage.sh
```

## Deployments
### Deployment via AWS
- [Terraform deployment](infra/terraform/aws/README.md)

### Deployment via GCP
- [Terraform deployment](infra/terraform/gcp/README.md)


## To-Do's

### Service
- [X] Initial setup of FastAPI project
- [ ] Make PaperProduct a nested object of Product
- [ ] Add Salesman and Sales entities

### Infra GCP
- [X] Terraform deployment with GCS backend
- [X] Initial setup of pipeline via GitHub Actions
- [X] Deployment to `prod` environment via pipeline
- [ ] Link service to domain name


### Infra GCP
- [ ] Terraform deployment with S3 backend
- [ ] Initial setup of pipeline via GitHub Actions
