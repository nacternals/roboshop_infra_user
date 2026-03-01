module "network" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//network?ref=v1.6.0"

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
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//security?ref=v1.6.0"

  project     = var.project
  environment = var.environment
  vpc_id      = module.network.vpc_id

  my_ip_cidr = var.my_ip_cidr
  app_port   = var.app_port

  common_tags = local.common_tags
}

module "iam" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//iam?ref=v1.6.0"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  # optional overrides
  role_name             = var.role_name
  instance_profile_name = var.instance_profile_name
  policy_name           = var.policy_name

  enable_lifecycle_actions = var.enable_lifecycle_actions
  passrole_arns            = var.passrole_arns
}


module "bastion" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//bastion?ref=v1.6.0"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  ami_id        = var.bastion_ami_id
  instance_type = var.bastion_instance_type

  subnet_id     = module.network.public_subnet_ids[0]
  bastion_sg_id = module.security.bastion_sg_id

  key_name                  = var.bastion_key_name
  iam_instance_profile_name = module.iam.instance_profile_name

  ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name

}

module "mongodb" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//mongodb?ref=v1.6.0"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  ami_id        = var.mongodb_ami_id
  instance_type = var.db_instance_type
  key_name      = var.db_key_name

  subnet_id = module.network.private_db_subnet_ids[0]
  sg_id     = module.security.mongodb_sg_id

  iam_instance_profile_name = module.iam.instance_profile_name
ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name

  depends_on = [module.bastion]
}

module "mysql" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//mysql?ref=v1.6.0"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  ami_id        = var.mysql_ami_id
  instance_type = var.db_instance_type
  key_name      = var.db_key_name

  subnet_id = module.network.private_db_subnet_ids[1]
  sg_id     = module.security.mysql_sg_id

  iam_instance_profile_name = module.iam.instance_profile_name
ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name

  depends_on = [module.bastion]
}

module "redis" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//redis?ref=v1.6.0"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  ami_id        = var.redis_ami_id
  instance_type = var.db_instance_type
  key_name      = var.db_key_name

  subnet_id = module.network.private_db_subnet_ids[0]
  sg_id     = module.security.redis_sg_id

  iam_instance_profile_name = module.iam.instance_profile_name
ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name

  depends_on = [module.bastion]
}

module "rabbitmq" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//rabbitmq?ref=v1.6.0"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  ami_id        = var.rabbitmq_ami_id
  instance_type = var.db_instance_type
  key_name      = var.db_key_name

  subnet_id = module.network.private_db_subnet_ids[1]
  sg_id     = module.security.rabbitmq_sg_id

  iam_instance_profile_name = module.iam.instance_profile_name
ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name

  depends_on = [module.bastion]
}