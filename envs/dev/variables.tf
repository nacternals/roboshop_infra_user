# Core
variable "aws_region" { type = string }
variable "project"    { type = string }
variable "environment" { type = string }

# Network
variable "vpc_cidr" { type = string }

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_nginx_subnet_cidrs" {
  type = list(string)
}

variable "private_app_subnet_cidrs" {
  type = list(string)
}

variable "private_db_subnet_cidrs" {
  type = list(string)
}

# Security
variable "my_ip_cidr" {
  description = "Your public IP in CIDR format e.g. 1.2.3.4/32"
  type        = list(string)
}

variable "app_port" {
  description = "App port allowed from nginx to internal ALB (if used in security module)"
  type        = number
  default     = 8080
}

# IAM (optional overrides)
variable "role_name" {
  type    = string
  default = null
}

variable "instance_profile_name" {
  type    = string
  default = null
}

variable "policy_name" {
  type    = string
  default = null
}

variable "enable_lifecycle_actions" {
  type    = bool
  default = false
}

variable "passrole_arns" {
  type    = list(string)
  default = []
}

# Bastion
variable "bastion_ami_id" { type = string }
variable "bastion_instance_type" {
  type    = string
  default = "t2.micro"
}
variable "bastion_key_name" { type = string }

# DB Tier
variable "db_instance_type" {
  type    = string
  default = "t2.micro"
}
variable "db_key_name" { type = string }

variable "mongodb_ami_id"  { type = string }
variable "mysql_ami_id"    { type = string }
variable "redis_ami_id"    { type = string }
variable "rabbitmq_ami_id" { type = string }

# Route53 Private Zone
variable "private_zone_name" {
  description = "Private hosted zone name. Example: dev.optimusprime.uno"
  type        = string
}

# App Tier (ASG defaults for all services)
variable "app_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "app_desired" {
  type    = number
  default = 1
}

variable "app_min" {
  type    = number
  default = 1
}

variable "app_max" {
  type    = number
  default = 2
}

variable "cpu_target" {
  description = "ASG target tracking CPU percent"
  type        = number
  default     = 60
}

# Microservice AMIs (golden)
variable "catalogue_ami_id" { type = string }
variable "cart_ami_id"      { type = string }
variable "user_ami_id"      { type = string }
variable "shipping_ami_id"  { type = string }
variable "payment_ami_id"   { type = string }
variable "dispatch_ami_id"  { type = string }