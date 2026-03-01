locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  # Take first 2 AZs automatically (matches your network module input)
  azs = slice(sort(data.aws_availability_zones.available.names), 0, 2)

  # Where bastion will write pubkey, and DB modules will read pubkey from
  ansadmin_pubkey_ssm_parameter_name = "/${var.project}/${var.environment}/ansible/ansadmin_pubkey"
}