module "network" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//network?ref=v1.1.0"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  vpc_cidr = var.vpc_cidr

  azs                        = local.azs
  public_subnet_cidrs        = var.public_subnet_cidrs
  private_nginx_subnet_cidrs = var.private_nginx_subnet_cidrs
  private_app_subnet_cidrs   = var.private_app_subnet_cidrs
  private_db_subnet_cidrs    = var.private_db_subnet_cidrs
}

module "security" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//security?ref=v1.2.0"

  project     = var.project
  environment = var.environment
  vpc_id      = module.network.vpc_id

  my_ip_cidr = var.my_ip_cidr
  app_port   = var.app_port

  common_tags = local.common_tags
}

