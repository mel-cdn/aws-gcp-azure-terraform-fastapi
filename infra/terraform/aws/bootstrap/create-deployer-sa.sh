#!/usr/bin/env bash

set -e -u

# Run this with an AWS IAM account that has permissions to create IAM users, roles, and policies.
# Example usage:
#   ./create-deployer-sa.sh <environment> <s3-terraform-state-bucket> <dynamodb-terraform-locks-table>

ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
ENVIRONMENT="$1"
S3_TERRAFORM_STATE_BUCKET="$2"
DYNAMODB_TERRAFORM_LOCKS_TABLE="$3"
USER_NAME="pg-dm-$ENVIRONMENT-tf-deployer-sa"
DESCRIPTION="CI/CD IAM User for Terraform"
POLICY_NAME="pg-dm-$ENVIRONMENT-tf-deployer-policy"


echo "> Creating IAM user: $USER_NAME"

aws iam create-user \
  --user-name "$USER_NAME" \
  --tags Key=Description,Value="$DESCRIPTION" \
  >/dev/null || echo "Done."

sed -e "s/{{ACCOUNT_ID}}/$ACCOUNT_ID/g" \
  -e "s/{{ENVIRONMENT}}/$ENVIRONMENT/g" \
  -e "s/{{S3_TERRAFORM_STATE_BUCKET}}/$S3_TERRAFORM_STATE_BUCKET/g" \
  -e "s/{{DYNAMODB_TERRAFORM_LOCKS_TABLE}}/$DYNAMODB_TERRAFORM_LOCKS_TABLE/g" \
  ./bootstrap/deployer-policy-template.json > deployer-policy.json

aws iam put-user-policy \
  --user-name "$USER_NAME" \
  --policy-name "$POLICY_NAME" \
  --policy-document file://deployer-policy.json

echo "> IAM user $USER_NAME created and policies attached."
