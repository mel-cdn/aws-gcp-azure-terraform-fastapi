#!/usr/bin/env bash

set -e -u

# Run this with an authenticated Azure account/profile that has permissions to create Storage Accounts
# Example usage:
#   ./create-terraform-state-resources.sh <resource-group> <storage-account-name> <location>

RESOURCE_GROUP="$1"
STORAGE_ACCOUNT_NAME="$2"
LOCATION="$3"
CONTAINER_NAME="terraform-state"

echo "> Creating $STORAGE_ACCOUNT_NAME Storage Account on $LOCATION.."

az storage account create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$STORAGE_ACCOUNT_NAME" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --encryption-services blob

echo "> Creating container.."
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT_NAME"

echo "============================================="
echo "> Storage Account: $STORAGE_ACCOUNT_NAME created."
echo "> Container Name: $CONTAINER_NAME created."
