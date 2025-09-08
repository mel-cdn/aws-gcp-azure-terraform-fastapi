terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
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
        EOF
  }
  depends_on = [null_resource.build-image]
}

#
# # Build & push Docker image
# resource "null_resource" "docker_build_push" {
#   triggers = {
#     source_hash = filesha1("Dockerfile") # rebuild only when Dockerfile changes
#   }
#
#   provisioner "local-exec" {
#     command = <<EOT
#       # Login to ACR
#       az acr login --name ${data.azurerm_container_registry.example.name}
#
#       # Build image
#       docker build -t ${data.azurerm_container_registry.example.login_server}/fastapi:latest .
#
#       # Push image
#       docker push ${data.azurerm_container_registry.example.login_server}/fastapi:latest
#
#       # Save digest after push
#       docker inspect --format='{{index .RepoDigests 0}}' ${data.azurerm_container_registry.example.login_server}/fastapi:latest > image_digest.txt
#     EOT
#   }
# }
#
# # Read digest into Terraform
# data "local_file" "image_digest" {
#   depends_on = [null_resource.docker_build_push]
#   filename = "${path.module}/image_digest.txt"
# }
#
# # Output digest
# output "fastapi_image_digest" {
#   value = data.local_file.image_digest.content
# }
#
# # Cleanup old images in ACR (retain only latest)
# resource "null_resource" "cleanup_images" {
#   depends_on = [null_resource.docker_build_push]
#
#   provisioner "local-exec" {
#     command = <<EOT
#       # List all tags except 'latest' and delete them
#       for tag in $(az acr repository show-tags \
#         --name ${data.azurerm_container_registry.example.name} \
#         --repository fastapi \
#         --output tsv | grep -v latest); do
#           az acr repository delete \
#             --name ${data.azurerm_container_registry.example.name} \
#             --repository fastapi \
#             --tag $tag --yes
#       done
#     EOT
#   }
# }
