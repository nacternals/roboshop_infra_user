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

  # DB private DNS records created in Route53 private zone module
  db_records = {
    mongodb  = module.mongodb.private_ip
    mysql    = module.mysql.private_ip
    redis    = module.redis.private_ip
    rabbitmq = module.rabbitmq.private_ip
  }

}