terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.8.0"
    }
  }
}

locals {
  normalized_billing_tags = {
    for k, v in var.billing_tags : lower(k) => lower(v)
  }
  working_dir      = "${path.root}/../../../" # 3 levels up to the root where Docker requirements resides
  image_tag_prefix = aws_ecr_repository.docker-image-repo.repository_url
  image_tag_latest = "${local.image_tag_prefix}:latest"
}

data "aws_caller_identity" "current" {}

# ----------------------------------------------------------------------------------------------------------------------
# ECR (Docker Repository)
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_ecr_repository" "docker-image-repo" {
  name                 = var.repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = local.normalized_billing_tags
}

# ----------------------------------------------------------------------------------------------------------------------
# Build Docker image
# ----------------------------------------------------------------------------------------------------------------------
resource "null_resource" "build-image" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    working_dir = local.working_dir
    command     = <<EOF
        echo "> Extracting Python dependencies..."
        pipenv requirements --categories default > requirements.txt

        echo "> Building docker image..."
        docker build --platform linux/amd64 --file=docker/Dockerfile -t ${local.image_tag_latest} .
        EOF
  }
  depends_on = [aws_ecr_repository.docker-image-repo]
}

# ----------------------------------------------------------------------------------------------------------------------
# Push Docker image to ECR
# ----------------------------------------------------------------------------------------------------------------------
resource "null_resource" "push-image" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    working_dir = local.working_dir
    command     = <<EOF
        echo "> Authenticating to Amazon ECR..."
        aws ecr get-login-password --region ${var.region} | docker login \
          --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com

        echo "> Pushing app image..."
        docker push ${local.image_tag_latest}
        EOF
  }
  depends_on = [null_resource.build-image]
}
