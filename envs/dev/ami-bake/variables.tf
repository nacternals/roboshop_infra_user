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

variable "component_instance_ids" {
  type = map(string)
}

variable "build_date" {
  type = string
}