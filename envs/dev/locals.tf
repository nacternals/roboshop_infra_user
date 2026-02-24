########################################
# Local Values
########################################

locals {

  # Standard name prefix used across resources
  name_prefix = lower("${var.project}-${var.environment}")

  # Common tags (if you want to reuse manually)
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  # Availability zone count
  az_count = length(var.azs)

}