locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }

  component_tiers = {
    mongodb   = "db"
    mysql     = "db"
    redis     = "db"
    rabbitmq  = "db"
    catalogue = "app"
    user      = "app"
    cart      = "app"
    shipping  = "app"
    payment   = "app"
    dispatch  = "app"
    nginx     = "web"
  }

  component_instance_ids = {
    mongodb   = data.aws_instances.mongodb.ids[0]
    mysql     = data.aws_instances.mysql.ids[0]
    redis     = data.aws_instances.redis.ids[0]
    rabbitmq  = data.aws_instances.rabbitmq.ids[0]
    catalogue = data.aws_instances.catalogue.ids[0]
    user      = data.aws_instances.user.ids[0]
    cart      = data.aws_instances.cart.ids[0]
    shipping  = data.aws_instances.shipping.ids[0]
    payment   = data.aws_instances.payment.ids[0]
    dispatch  = data.aws_instances.dispatch.ids[0]
    nginx     = data.aws_instances.nginx.ids[0]
  }
}