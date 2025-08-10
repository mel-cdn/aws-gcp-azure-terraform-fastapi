#!/usr/bin/env bash

set -e -u

echo "> Installing Python dependencies..."
python -m pip install --upgrade pip
pipenv install --dev

echo "> Done!"
