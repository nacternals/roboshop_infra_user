locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  azs = slice(sort(data.aws_availability_zones.available.names), 0, 2)
}

