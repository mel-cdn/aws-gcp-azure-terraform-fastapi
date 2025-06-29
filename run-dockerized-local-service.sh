#!/usr/bin/env bash

set -e -u

echo "> Extracting Python dependencies..."
pipenv run pip freeze > requirements.txt

echo "> Building docker image..."
docker build --file=containers/Dockerfile -t dm-inventory-service .

echo "> Running FastAPI service..."
docker run --env-file .env.local -p 8080:8080 dm-inventory-service
