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

output "bastion_sg_id" {
  value = module.security.bastion_sg_id
}
