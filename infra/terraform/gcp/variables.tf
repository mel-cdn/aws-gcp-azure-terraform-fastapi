variable "project_id" {
  type        = string
  default     = "playground-mel"
  description = "Change this to the target Google Project ID"
}

variable "location" {
  type    = string
  default = "asia-east1"
}

variable "app_name" {
  type    = string
  default = "dm-inventory-service"
}
