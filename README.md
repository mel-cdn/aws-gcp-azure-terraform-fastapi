# Dunder Mifflin Inventory Service

[![PROD Build Status](https://github.com/mel-cdn/dm-inventory-service/actions/workflows/gcp_deploy.yml/badge.svg?branch=main)](https://github.com/mel-cdn/dm-inventory-service/actions/workflows/gcp_deploy.yml)

## Overview

This repository serves as a sandbox/playground for experimenting with a Domain-Driven Design (DDD) approach in a FastAPI
application. It focuses on managing paper product inventory, sales personnel, and sales transactions.

## Highlights

- Domain-Driven Design using FastAPI
- Dockerized service
- Google Cloud Project (GCP) deployment
- Amazon Web Service (AWS) deployment
- Terraform deployments for GCP and AWS
- CI/CD via GitHub Actions

## Getting Started

### Prerequisites

Ensure you have the following:

- **Python**
    - Install >= [Python 3.12](https://www.python.org/)
- **Google Cloud Project**
    - [Google Cloud Account](https://console.cloud.google.com/)
    - Install [gcloud CLI](https://cloud.google.com/sdk/docs/install)
- **Amazon Web Services**
    - [AWS Account](https://aws.amazon.com/)
    - Install [aws CLI](https://aws.amazon.com/cli/)
- **Docker**
    - Install [Docker Desktop or CLI](https://docs.docker.com/desktop/)
- **Terraform**
    - Install [Terraform CLI](https://developer.hashicorp.com/terraform/install)

### Installation

```bash

# Clone repository
git clone git@github.com:mel-cdn/dm-inventory-service.git

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

# Run pytest tests
./run-unit-tests-with-coverage.sh
```

## Infrastructure as Code (IAC) Deployments

- [AWS via Terraform](infra/terraform/aws/README.md)
- [GCP via Terraform](infra/terraform/gcp/README.md)

## To-Do

### Service

- [X] Initial setup of FastAPI project
- [ ] Make PaperProduct a nested object of Product
- [ ] Add Salesman and Sales entities
- [ ] Add actual database: Cloud Storage for GCP
- [ ] Add actual database: S3 for AWS

### Infra GCP

- [X] Terraform deployment with GCS backend
- [X] Initial setup of pipeline via GitHub Actions
- [X] Deployment to `prod` environment via pipeline
- [ ] Link service to a domain name

### Infra GCP

- [ ] Terraform deployment with S3 backend
- [ ] Initial setup of pipeline via GitHub Actions
- [ ] Deployment to `prod` environment via pipeline
- [ ] Link service to a domain name
