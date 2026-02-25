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
# Network module inputs
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
# Security module inputs
############################
variable "my_ip_cidr" {
  type        = list(string)
  description = "Your public IP CIDR(s), e.g. [\"x.x.x.x/32\"]"
}

variable "app_port" {
  type        = number
  default     = 8080
  description = "Microservices port"
}

############################
# IAM module inputs (optional overrides)
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
# Bastion module inputs
############################
variable "bastion_ami_id" {
  type        = string
  description = "AMI ID for bastion/ansible controller"
}

variable "bastion_instance_type" {
  type        = string
  description = "Instance type of bastion/ansible controller"
}

variable "bastion_key_name" {
  type        = string
  description = "Existing EC2 key pair name"
}

