#!/usr/bin/env bash

set -e -u

THRESHOLD=100

export PYTHONPATH=src
export DISABLE_CACHE=True

echo "> Running tests with threshold coverage: $THRESHOLD%"

python -m pytest \
  --cov-config=.coveragerc \
  --cov=src \
  --no-cov-on-fail \
  --cov-fail-under=$THRESHOLD \
  --cov-branch \
  --cov-report=term \
  --cov-report=html:tmp/htmlcov \
  --cov-report=xml:tmp/coverage.xml \
  -o cache_dir=tmp/.pytest_cache \
  -s \
  --junitxml=tmp/junit/junit.xml \
  tests/unit

echo "> Done!"
