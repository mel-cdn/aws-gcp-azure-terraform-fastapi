# Dunder Mifflin Inventory Service

## Overview

This repository serves as a sandbox/playground for experimenting with a Domain-Driven Design (DDD) approach in a FastAPI
application. It focuses on managing paper product inventory, sales personnel, and sales transactions.

## Highlights (WIP)

- Domain-Driven Design using FastAPI
- Dockerized service
- Google Cloud Project deployment via Terraform on CircleCI pipeline

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
pip install pipenv

# Activate Pipenv environment
pipenv shell

# Install dependencies
./run-pip-updates.sh

# Run locally
./run-local-service.sh
```

## Configuration

Configure environment variables as needed at `.env.local`

## Testing

```bash

# Run tests
./run-unit-tests-with-coverage.sh
```

## More...

- Make PaperProduct a nested object of Product
- Add Salesman and Sales entities
