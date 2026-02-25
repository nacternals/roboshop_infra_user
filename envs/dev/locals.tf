locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  # pick first 2 AZs in the region (stable ordering)
  azs = slice(sort(data.aws_availability_zones.available.names), 0, 2)


  # Auto-generated SSM parameter path
  ansadmin_pubkey_ssm_parameter_name = "/${var.project}/${var.environment}/ansible/ansadmin_pubkey"

}