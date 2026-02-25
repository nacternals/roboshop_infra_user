###############################
# Network Module Outputs
###############################
output "vpc_id" {
  value       = module.network.vpc_id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = module.network.public_subnet_ids
  description = "Public subnet IDs"
}

output "private_nginx_subnet_ids" {
  value       = module.network.private_nginx_subnet_ids
  description = "Private Nginx subnet IDs"
}

output "private_app_subnet_ids" {
  value       = module.network.private_app_subnet_ids
  description = "Private App subnet IDs"
}

output "private_db_subnet_ids" {
  value       = module.network.private_db_subnet_ids
  description = "Private DB subnet IDs"
}

output "igw_id" {
  value       = module.network.igw_id
  description = "Internet Gateway ID"
}

output "nat_gateway_ids" {
  value       = module.network.nat_gateway_ids
  description = "NAT Gateway IDs"
}

output "public_route_table_id" {
  value       = module.network.public_route_table_id
  description = "Public route table ID"
}



############################
# Security Module Outputs
############################

output "bastion_sg_id" {
  value = module.security.bastion_sg_id
}

output "alb_public_sg_id" {
  value = module.security.alb_public_sg_id
}

output "nginx_sg_id" {
  value = module.security.nginx_sg_id
}

output "alb_internal_sg_id" {
  value = module.security.alb_internal_sg_id
}

output "app_sg_id" {
  value = module.security.app_sg_id
}

output "mongodb_sg_id" {
  value = module.security.mongodb_sg_id
}

output "mysql_sg_id" {
  value = module.security.mysql_sg_id
}

output "redis_sg_id" {
  value = module.security.redis_sg_id
}

output "rabbitmq_sg_id" {
  value = module.security.rabbitmq_sg_id
}



###############################
# IAM Module Outputs
###############################
output "iam_role_name" {
  value = module.iam.role_name
}

output "iam_role_arn" {
  value = module.iam.role_arn
}

output "iam_instance_profile_name" {
  value = module.iam.instance_profile_name
}

output "iam_instance_profile_arn" {
  value = module.iam.instance_profile_arn
}

output "iam_policy_arn" {
  value = module.iam.policy_arn
}
