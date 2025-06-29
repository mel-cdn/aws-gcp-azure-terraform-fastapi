# Dunder Mifflin Inventory Service

A Domain-Driven Design (DDD) FastAPI application for managing paper products inventory, salesmen, and sales
transactions.

## Requirements

1. Install [Python 3.12](https://www.python.org/)

## Getting Started

```bash

# Install Pipenv
pip install pipenv

# Activate Pipenv environment
pipenv shell

# Install dependencies
./run-pip-updates.sh
```

## Project Scripts

```bash

# Install all dependencies for development. Executes unit tests with coverage
$ ./run-checks.sh

# Run a Dockerized API server locally on port 9000

# Run unit tests only with coverage. Use this before pushing to repo :)
$ ./run-unit-tests-with-coverage.sh
```
