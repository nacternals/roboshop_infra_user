# # ----------------------------
# Network
# ----------------------------
module "network" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//01_network?ref=v1.18.0"

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

# ----------------------------
# Security (bastion + db + internal alb sgs)
# ----------------------------
module "security" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//02_security?ref=v1.18.0"

  project     = var.project
  environment = var.environment
  vpc_id      = module.network.vpc_id

  my_ip_cidr = var.my_ip_cidr
  app_port   = var.app_port

  common_tags = local.common_tags
}

# ----------------------------
# IAM (instance profile)
# ----------------------------
module "iam" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//03_iam?ref=v1.18.0"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  role_name             = var.role_name
  instance_profile_name = var.instance_profile_name
  policy_name           = var.policy_name

  enable_lifecycle_actions = var.enable_lifecycle_actions
  passrole_arns            = var.passrole_arns
}

# ----------------------------
# Bastion
# ----------------------------
module "bastion" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//04_bastion?ref=v1.18.0"

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

# # ----------------------------
# # DB Tier
# # ----------------------------
module "mongodb" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//05_mongodb?ref=v1.18.0"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  ami_id        = var.mongodb_ami_id
  instance_type = var.db_instance_type
  key_name      = var.db_key_name

  subnet_id = module.network.private_db_subnet_ids[0]
  sg_id     = module.security.mongodb_sg_id

  iam_instance_profile_name          = module.iam.instance_profile_name
  ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name

  depends_on = [module.bastion]
}

module "mysql" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//06_mysql?ref=v1.18.0"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  ami_id        = var.mysql_ami_id
  instance_type = var.db_instance_type
  key_name      = var.db_key_name

  subnet_id = module.network.private_db_subnet_ids[1]
  sg_id     = module.security.mysql_sg_id

  iam_instance_profile_name          = module.iam.instance_profile_name
  ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name

  depends_on = [module.bastion]
}

module "redis" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//07_redis?ref=v1.18.0"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  ami_id        = var.redis_ami_id
  instance_type = var.db_instance_type
  key_name      = var.db_key_name

  subnet_id = module.network.private_db_subnet_ids[0]
  sg_id     = module.security.redis_sg_id

  iam_instance_profile_name          = module.iam.instance_profile_name
  ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name

  depends_on = [module.bastion]
}

module "rabbitmq" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//08_rabbitmq?ref=v1.18.0"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  ami_id        = var.rabbitmq_ami_id
  instance_type = var.db_instance_type
  key_name      = var.db_key_name

  subnet_id = module.network.private_db_subnet_ids[1]
  sg_id     = module.security.rabbitmq_sg_id

  iam_instance_profile_name          = module.iam.instance_profile_name
  ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name

  depends_on = [module.bastion]
}

# # ----------------------------
# # Internal ALB (APP tier)
# # ----------------------------
# module "internal_alb" {
#   source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//internal-alb?ref=v1.13.0"

#   project     = var.project
#   environment = var.environment
#   common_tags = local.common_tags

#   vpc_id              = module.network.vpc_id
#   private_app_subnets = module.network.private_app_subnet_ids

#   nginx_sg_id   = module.security.nginx_sg_id
#   listener_port = 80

#   depends_on = [module.network, module.security]
# }

# # ----------------------------
# # Route53 Private Hosted Zone
# # ----------------------------
# module "route53_private" {
#   source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//route53-private?ref=v1.13.0"

#   project     = var.project
#   environment = var.environment
#   common_tags = local.common_tags

#   vpc_id = module.network.vpc_id

#   zone_name    = var.private_zone_name
#   alb_dns_name = module.internal_alb.alb_dns_name
#   alb_zone_id  = module.internal_alb.alb_zone_id

#   depends_on = [module.internal_alb]
# }

# # ----------------------------
# # APP Tier Services (Option A)
# # Each module creates its own SG (no app_nodes_sg_id)
# # ----------------------------
# module "service_catalogue" {
#   source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//service-catalogue?ref=v1.13.0"

#   project     = var.project
#   environment = var.environment
#   common_tags = local.common_tags

#   vpc_id              = module.network.vpc_id
#   private_app_subnets = module.network.private_app_subnet_ids

#   listener_arn  = module.internal_alb.listener_arn
#   alb_sg_id     = module.security.alb_internal_sg_id
#   bastion_sg_id = module.security.bastion_sg_id

#   host_header   = "catalogue.${var.private_zone_name}"
#   rule_priority = 10

#   ami_id        = var.catalogue_ami_id
#   instance_type = var.app_instance_type

#   desired    = var.app_desired
#   min        = var.app_min
#   max        = var.app_max
#   cpu_target = var.cpu_target

#   depends_on = [module.internal_alb, module.bastion]
# }

# module "service_cart" {
#   source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//service-cart?ref=v1.13.0"

#   project     = var.project
#   environment = var.environment
#   common_tags = local.common_tags

#   vpc_id              = module.network.vpc_id
#   private_app_subnets = module.network.private_app_subnet_ids

#   listener_arn  = module.internal_alb.listener_arn
#   alb_sg_id     = module.security.alb_internal_sg_id
#   bastion_sg_id = module.security.bastion_sg_id

#   host_header   = "cart.${var.private_zone_name}"
#   rule_priority = 20

#   ami_id        = var.cart_ami_id
#   instance_type = var.app_instance_type

#   desired    = var.app_desired
#   min        = var.app_min
#   max        = var.app_max
#   cpu_target = var.cpu_target

#   depends_on = [module.internal_alb, module.bastion]
# }

# module "service_user" {
#   source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//service-user?ref=v1.13.0"

#   project     = var.project
#   environment = var.environment
#   common_tags = local.common_tags

#   vpc_id              = module.network.vpc_id
#   private_app_subnets = module.network.private_app_subnet_ids

#   listener_arn  = module.internal_alb.listener_arn
#   alb_sg_id     = module.security.alb_internal_sg_id
#   bastion_sg_id = module.security.bastion_sg_id

#   host_header   = "user.${var.private_zone_name}"
#   rule_priority = 30

#   ami_id        = var.user_ami_id
#   instance_type = var.app_instance_type

#   desired    = var.app_desired
#   min        = var.app_min
#   max        = var.app_max
#   cpu_target = var.cpu_target

#   depends_on = [module.internal_alb, module.bastion]
# }

# module "service_shipping" {
#   source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//service-shipping?ref=v1.13.0"

#   project     = var.project
#   environment = var.environment
#   common_tags = local.common_tags

#   vpc_id              = module.network.vpc_id
#   private_app_subnets = module.network.private_app_subnet_ids

#   listener_arn  = module.internal_alb.listener_arn
#   alb_sg_id     = module.security.alb_internal_sg_id
#   bastion_sg_id = module.security.bastion_sg_id

#   host_header   = "shipping.${var.private_zone_name}"
#   rule_priority = 40

#   ami_id        = var.shipping_ami_id
#   instance_type = var.app_instance_type

#   desired    = var.app_desired
#   min        = var.app_min
#   max        = var.app_max
#   cpu_target = var.cpu_target

#   depends_on = [module.internal_alb, module.bastion]
# }

# module "service_payment" {
#   source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//service-payment?ref=v1.13.0"

#   project     = var.project
#   environment = var.environment
#   common_tags = local.common_tags

#   vpc_id              = module.network.vpc_id
#   private_app_subnets = module.network.private_app_subnet_ids

#   listener_arn  = module.internal_alb.listener_arn
#   alb_sg_id     = module.security.alb_internal_sg_id
#   bastion_sg_id = module.security.bastion_sg_id

#   host_header   = "payment.${var.private_zone_name}"
#   rule_priority = 50

#   ami_id        = var.payment_ami_id
#   instance_type = var.app_instance_type

#   desired    = var.app_desired
#   min        = var.app_min
#   max        = var.app_max
#   cpu_target = var.cpu_target

#   depends_on = [module.internal_alb, module.bastion]
# }

# module "service_dispatch" {
#   source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//service-dispatch?ref=v1.13.0"

#   project     = var.project
#   environment = var.environment
#   common_tags = local.common_tags

#   vpc_id              = module.network.vpc_id
#   private_app_subnets = module.network.private_app_subnet_ids

#   listener_arn  = module.internal_alb.listener_arn
#   alb_sg_id     = module.security.alb_internal_sg_id
#   bastion_sg_id = module.security.bastion_sg_id

#   host_header   = "dispatch.${var.private_zone_name}"
#   rule_priority = 60

#   ami_id        = var.dispatch_ami_id
#   instance_type = var.app_instance_type

#   desired    = var.app_desired
#   min        = var.app_min
#   max        = var.app_max
#   cpu_target = var.cpu_target

#   depends_on = [module.internal_alb, module.bastion]
# }