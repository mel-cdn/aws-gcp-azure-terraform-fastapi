terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  required_version = ">= 1.5.0"
}

locals {
  normalized_billing_tags = {
    for k, v in var.billing_tags : lower(k) => lower(v)
  }
  working_dir = "${path.root}/../../../" # 3 levels up to the root where Docker requirements resides
  resource_prefix_alnum = lower(replace(var.resource_prefix, "-", ""))
  repo_tag_latest = "${azurerm_container_registry.container.login_server}/${var.repo_name}:latest"
}

# ----------------------------------------------------------------------------------------------------------------------
# Retrieve created resources for outputs
# ----------------------------------------------------------------------------------------------------------------------
data "local_file" "image_digest" {
  filename = "${local.working_dir}digest.txt"

  depends_on = [
    null_resource.push-image
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Container Registry
# ----------------------------------------------------------------------------------------------------------------------
resource "azurerm_container_registry" "container" {
  name                = "${local.resource_prefix_alnum}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true

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
        docker build --platform linux/amd64 --file=docker/Dockerfile -t ${local.repo_tag_latest} .
        EOF
  }
  depends_on = [azurerm_container_registry.container]
}

# ----------------------------------------------------------------------------------------------------------------------
# Push Docker image to Container Registry
# ----------------------------------------------------------------------------------------------------------------------
resource "null_resource" "push-image" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    working_dir = local.working_dir
    command     = <<EOF
        echo "> Authenticating to ACR..."
        az acr login --name ${azurerm_container_registry.container.name}

        echo "> Pushing app image..."
        docker push ${local.repo_tag_latest}

        echo "> Retrieving the image's latest digest..."
        docker inspect --format='{{index .RepoDigests 0}}' ${local.repo_tag_latest} > digest.txt
        EOF
  }
  depends_on = [null_resource.build-image]
}
