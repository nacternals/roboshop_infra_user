############################
# Core
############################
variable "aws_region" {
  type = string
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

############################
# Network inputs
############################
variable "vpc_cidr" {
  type = string
}

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

############################
# Security inputs
############################
variable "my_ip_cidr" {
  type = list(string)
}

variable "app_port" {
  type    = number
  default = 8080
}

############################
# IAM inputs (optional overrides)
############################
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

############################
# Bastion inputs
############################
variable "bastion_ami_id" {
  type = string
}

variable "bastion_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "bastion_key_name" {
  type = string
}

############################
# DB tier inputs (golden AMIs)
############################
variable "db_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "db_key_name" {
  type = string
}

variable "mongodb_ami_id" {
  type = string
}

variable "mysql_ami_id" {
  type = string
}

variable "redis_ami_id" {
  type = string
}

variable "rabbitmq_ami_id" {
  type = string
}