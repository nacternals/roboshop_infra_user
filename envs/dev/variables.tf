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

variable "azs" {
  type        = list(string)
  description = "List of AZs (e.g., [us-east-1a, us-east-1b])"
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



