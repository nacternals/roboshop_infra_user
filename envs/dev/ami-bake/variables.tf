variable "aws_region" {
  type = string
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "ami_version" {
  type = string
}

variable "build_date" {
  type = string
}

variable "stop_before_ami_components" {
  type = set(string)
}