#!/usr/bin/env bash

set -e -u

# Run this with an authenticated Azure account/profile that has permissions to create Service Principal (SPN)
# Example usage:
#   ./create-deployer-sa.sh <subscription-id>


SUBSCRIPTION_ID="$1"
SCOPES="/subscriptions/$SUBSCRIPTION_ID"
SA_NAME="dm-terraform-deployer-sa"
ROLES=(
  "Contributor"                 # Container App, Networking, etc.
  "User Access Administrator"   # Service Account Management
)

# 1. Create SPN
# Note: This will reset the clientSecret everytime.
echo "> Creating Service Principal: $SA_NAME"
az ad sp create-for-rbac \
  --name "$SA_NAME" \
  --skip-assignment \
  --sdk-auth

APP_ID=$(az ad sp list --display-name dm-terraform-deployer-sa --query "[].appId" -o tsv)

# 2. Assign roles
for ROLE in "${ROLES[@]}"; do
  echo "Assigning '$ROLE' to '$APP_ID'..."
  az role assignment create \
  --assignee "$APP_ID" \
  --role "$ROLE" \
  --scope "$SCOPES" \
  >/dev/null || true
done

echo "> Service Principal created with attached roles."
