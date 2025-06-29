#!/usr/bin/env bash

set -e -u

./run-pip-updates.sh

pre-commit install

./run-unit-tests-with-coverage.sh
