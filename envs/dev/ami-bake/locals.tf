locals {

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }

  component_tiers = {

    mongodb  = "db"
    mysql    = "db"
    redis    = "db"
    rabbitmq = "db"

    catalogue = "app"
    user      = "app"
    cart      = "app"
    shipping  = "app"
    payment   = "app"
    dispatch  = "app"

    nginx = "web"
  }

}