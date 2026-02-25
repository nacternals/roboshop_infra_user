###########################
# Network Module
###########################
variable "aws_region" {
  type        = string
  description = "AWS Region (e.g., us-east-1)"
}

variable "project" {
  type        = string
  description = "Project name (e.g., roboshop)"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev/stage/prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs (same length as azs)"
}

variable "private_nginx_subnet_cidrs" {
  type        = list(string)
  description = "Private Nginx subnet CIDRs (same length as azs)"
}

variable "private_app_subnet_cidrs" {
  type        = list(string)
  description = "Private App subnet CIDRs (same length as azs)"
}

variable "private_db_subnet_cidrs" {
  type        = list(string)
  description = "Private DB subnet CIDRs (same length as azs)"
}


###########################
# Security Module
###########################

variable "my_ip_cidr" {
  type        = list(string)
  description = "Your public IP CIDR(s) for SSH to bastion"
}

variable "app_port" {
  type = number
}


###########################
# IAM Module
###########################
# Optional overrides (keep them optional like module)
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
  default = true
}

variable "passrole_arns" {
  type    = list(string)
  default = ["*"]
}

