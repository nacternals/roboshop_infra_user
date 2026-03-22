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
    mongodb   = try(one(data.aws_instances.mongodb.ids), null)
    mysql     = try(one(data.aws_instances.mysql.ids), null)
    redis     = try(one(data.aws_instances.redis.ids), null)
    rabbitmq  = try(one(data.aws_instances.rabbitmq.ids), null)
    catalogue = try(one(data.aws_instances.catalogue.ids), null)
    user      = try(one(data.aws_instances.user.ids), null)
    cart      = try(one(data.aws_instances.cart.ids), null)
    shipping  = try(one(data.aws_instances.shipping.ids), null)
    payment   = try(one(data.aws_instances.payment.ids), null)
    dispatch  = try(one(data.aws_instances.dispatch.ids), null)
    nginx     = try(one(data.aws_instances.nginx.ids), null)
  }

  valid_component_instance_ids = {
    for k, v in local.component_instance_ids : k => v
    if v != null
  }

  effective_build_date = var.build_date != null ? var.build_date : formatdate("DDMMYYYY-hhmmss", timestamp())
}