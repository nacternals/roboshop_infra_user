########################################
# Network Outputs
########################################

output "vpc_id" {
  description = "VPC ID created by the network module"
  value       = module.network.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.network.vpc_cidr
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = module.network.igw_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_nginx_subnet_ids" {
  description = "Private Nginx subnet IDs"
  value       = module.network.private_nginx_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private App subnet IDs"
  value       = module.network.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private DB subnet IDs"
  value       = module.network.private_db_subnet_ids
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = module.network.public_route_table_id
}

output "private_route_table_ids" {
  description = "Private route table IDs (nginx/app/db)"
  value       = module.network.private_route_table_ids
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs (if created)"
  value       = module.network.nat_gateway_ids
}

output "nat_eip_ids" {
  description = "Elastic IP allocation IDs for NAT gateways (if created)"
  value       = module.network.nat_eip_ids
}