#!/usr/bin/env bash

set -e -u

export PYTHONPATH=src

echo "> Running local FastAPI service..."
uvicorn src.presentation.rest.app:app \
  --env-file .env.local \
  --host 0.0.0.0 \
  --port 9000 \
  --reload

echo "> Done!"
