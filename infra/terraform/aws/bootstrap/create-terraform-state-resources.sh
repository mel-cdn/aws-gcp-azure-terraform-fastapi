#!/usr/bin/env bash

set -e -u

# Run this with an authenticated AWS IAM account/profile that has permissions to create S3 buckets
# Example usage:
#   ./create-terraform-state-resources.sh <resource-prefix> <region>

RESOURCE_PREFIX="$1"
REGION="$2"
BUCKET_NAME="$RESOURCE_PREFIX-terraform-state"
DYNAMODB_TABLE="$RESOURCE_PREFIX-terraform-locks"


echo "> Creating $BUCKET_NAME S3 bucket on $REGION.."
aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --region "$REGION" \
  --create-bucket-configuration LocationConstraint="$REGION" \
  >/dev/null || echo "Done."

# Enable bucket versioning
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled

echo "> Creating $DYNAMODB_TABLE DynamoDB table on $REGION.."
aws dynamodb create-table \
  --table-name "$DYNAMODB_TABLE" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  >/dev/null || echo "Done."

echo "============================================="
echo "> S3 bucket: $BUCKET_NAME created."
echo "> DynamoDB table: $DYNAMODB_TABLE created."
