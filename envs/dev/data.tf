data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ssm_parameter" "catalogue_ami" {
  name = "/roboshop/dev/ami/catalogue"
}

data "aws_ssm_parameter" "user_ami" {
  name = "/roboshop/dev/ami/user"
}

data "aws_ssm_parameter" "cart_ami" {
  name = "/roboshop/dev/ami/cart"
}

data "aws_ssm_parameter" "shipping_ami" {
  name = "/roboshop/dev/ami/shipping"
}

data "aws_ssm_parameter" "payment_ami" {
  name = "/roboshop/dev/ami/payment"
}

data "aws_ssm_parameter" "dispatch_ami" {
  name = "/roboshop/dev/ami/dispatch"
}

data "aws_ssm_parameter" "nginx_ami" {
  name = "/roboshop/dev/ami/nginx"
}

data "aws_ssm_parameter" "mongodb_ami" {
  name = "/roboshop/dev/ami/mongodb"
}

data "aws_ssm_parameter" "mysql_ami" {
  name = "/roboshop/dev/ami/mysql"
}

data "aws_ssm_parameter" "redis_ami" {
  name = "/roboshop/dev/ami/redis"
}

data "aws_ssm_parameter" "rabbitmq_ami" {
  name = "/roboshop/dev/ami/rabbitmq"
}