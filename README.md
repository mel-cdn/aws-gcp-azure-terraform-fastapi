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

- [Python 3.12](https://www.python.org/)
- [Google Cloud Project Account](https://console.cloud.google.com/)
- [CircleCI Account](https://circleci.com/)
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Docker](https://docs.docker.com/get-started/)

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
