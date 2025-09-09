#!/usr/bin/env bash

set -e -u

export PYTHONPATH=src

echo "> Running local FastAPI service..."
uvicorn src.presentation.main:app \
  --env-file environment/.env.dev \
  --host 0.0.0.0 \
  --port 9000 \
  --reload

echo "> Done!"
