#!/usr/bin/env bash

set -e -u

echo "> Installing Python dependencies..."
pipenv install --dev

echo "> Done!"
