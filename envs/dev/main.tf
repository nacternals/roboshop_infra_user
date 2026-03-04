############################################
# main.tf (FINAL - issues fixed + proper order)
############################################

# ----------------------------
# Network
# ----------------------------
module "network" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//01_network?ref=v1.37.1"

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
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//02_security?ref=v1.37.1"

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
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//03_iam?ref=v1.37.1"

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
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//04_bastion?ref=v1.37.1"

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

# ----------------------------
# DB Tier
# ----------------------------
module "mongodb" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//05_mongodb?ref=v1.37.1"

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
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//06_mysql?ref=v1.37.1"

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
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//07_redis?ref=v1.37.1"

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
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//08_rabbitmq?ref=v1.37.1"

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

# ----------------------------
# Internal ALB (APP tier)
# ----------------------------
module "internal_alb" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//09_internal-alb?ref=v1.37.1"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  vpc_id              = module.network.vpc_id
  private_app_subnets = module.network.private_app_subnet_ids

  listener_port = 80
  alb_sg_id     = module.security.alb_internal_sg_id

  depends_on = [module.network, module.security]
}

# ----------------------------
# Route53 Private Hosted Zone
# ----------------------------
module "route53_private" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//10_route53-private?ref=v1.37.1"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  vpc_id = module.network.vpc_id

  zone_name    = var.private_zone_name
  alb_dns_name = module.internal_alb.alb_dns_name
  alb_zone_id  = module.internal_alb.alb_zone_id

  records = [
    "catalogue",
    "user",
    "cart",
    "shipping",
    "payment",
    "dispatch",
    "web"
  ]

  enable_wildcard = false
  db_records      = local.db_records

  depends_on = [module.internal_alb]
}

# ----------------------------
# APP Tier Services (Single shared app SG)
# ----------------------------
module "service_catalogue" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//11_service-catalogue?ref=v1.37.1"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  vpc_id              = module.network.vpc_id
  private_app_subnets = module.network.private_app_subnet_ids

  listener_arn = module.internal_alb.listener_arn
  app_sg_id    = module.security.app_sg_id

  host_header   = "catalogue.${var.private_zone_name}"
  rule_priority = 10

  ami_id        = var.catalogue_ami_id
  instance_type = var.app_instance_type

  desired    = var.app_desired
  min        = var.app_min
  max        = var.app_max
  cpu_target = var.cpu_target

  ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name
  iam_instance_profile_name          = module.iam.instance_profile_name

  depends_on = [module.internal_alb, module.bastion]
}

module "service_cart" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//12_service-cart?ref=v1.37.1"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  vpc_id              = module.network.vpc_id
  private_app_subnets = module.network.private_app_subnet_ids

  listener_arn = module.internal_alb.listener_arn
  app_sg_id    = module.security.app_sg_id

  host_header   = "cart.${var.private_zone_name}"
  rule_priority = 20

  ami_id        = var.cart_ami_id
  instance_type = var.app_instance_type

  desired    = var.app_desired
  min        = var.app_min
  max        = var.app_max
  cpu_target = var.cpu_target

  ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name
  iam_instance_profile_name          = module.iam.instance_profile_name

  depends_on = [module.internal_alb, module.bastion]
}

module "service_user" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//13_service-user?ref=v1.37.1"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  vpc_id              = module.network.vpc_id
  private_app_subnets = module.network.private_app_subnet_ids

  listener_arn = module.internal_alb.listener_arn
  app_sg_id    = module.security.app_sg_id

  host_header   = "user.${var.private_zone_name}"
  rule_priority = 30

  ami_id        = var.user_ami_id
  instance_type = var.app_instance_type

  desired    = var.app_desired
  min        = var.app_min
  max        = var.app_max
  cpu_target = var.cpu_target

  ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name
  iam_instance_profile_name          = module.iam.instance_profile_name

  depends_on = [module.internal_alb, module.bastion]
}

module "service_shipping" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//14_service-shipping?ref=v1.37.1"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  vpc_id              = module.network.vpc_id
  private_app_subnets = module.network.private_app_subnet_ids

  listener_arn = module.internal_alb.listener_arn
  app_sg_id    = module.security.app_sg_id

  host_header   = "shipping.${var.private_zone_name}"
  rule_priority = 40

  ami_id        = var.shipping_ami_id
  instance_type = var.app_instance_type

  desired    = var.app_desired
  min        = var.app_min
  max        = var.app_max
  cpu_target = var.cpu_target

  ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name
  iam_instance_profile_name          = module.iam.instance_profile_name

  depends_on = [module.internal_alb, module.bastion]
}

module "service_payment" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//15_service-payment?ref=v1.37.1"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  vpc_id              = module.network.vpc_id
  private_app_subnets = module.network.private_app_subnet_ids

  listener_arn = module.internal_alb.listener_arn
  app_sg_id    = module.security.app_sg_id

  host_header   = "payment.${var.private_zone_name}"
  rule_priority = 50

  ami_id        = var.payment_ami_id
  instance_type = var.app_instance_type

  desired    = var.app_desired
  min        = var.app_min
  max        = var.app_max
  cpu_target = var.cpu_target

  ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name
  iam_instance_profile_name          = module.iam.instance_profile_name

  depends_on = [module.internal_alb, module.bastion]
}

module "service_dispatch" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//16_service-dispatch?ref=v1.37.1"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  private_app_subnets = module.network.private_app_subnet_ids
  app_sg_id           = module.security.app_sg_id

  ami_id        = var.dispatch_ami_id
  instance_type = var.app_instance_type

  desired    = var.app_desired
  min        = var.app_min
  max        = var.app_max
  cpu_target = var.cpu_target

  rabbitmq_host = "rabbitmq.${var.private_zone_name}"
  rabbitmq_port = 5672

  ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name
  iam_instance_profile_name          = module.iam.instance_profile_name

  depends_on = [module.bastion]
}

# ----------------------------
# ACM (Public cert for Public ALB)  ✅ Option A (separate module)
# ----------------------------
module "acm_public" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//20_acm-public?ref=v1.37.1"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  zone_name = var.public_zone_name

  domain_name = "*.${var.public_zone_name}"
  subject_alternative_names = [
    var.public_zone_name,
    "web.dev.${var.public_zone_name}"
  ]
}

# ----------------------------
# Public ALB (Internet-facing)
# ----------------------------
module "public_alb" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//18_public-alb?ref=v1.37.1"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids

  certificate_arn = module.acm_public.certificate_arn

  enable_deletion_protection    = false
  idle_timeout                  = 60
  enable_http_to_https_redirect = true

  access_logs_enabled = false

  ingress_cidrs = ["0.0.0.0/0"]

  depends_on = [module.network, module.acm_public]
}

# ----------------------------
# Route53 Public Hosted Zone Records (web -> public ALB)
# ----------------------------
module "route53_public" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//19_route53-public?ref=v1.37.1"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  zone_name   = var.public_zone_name
  create_zone = false

  records         = ["web.dev"]
  enable_wildcard = false

  alb_dns_name = module.public_alb.alb_dns_name
  alb_zone_id  = module.public_alb.alb_zone_id

  depends_on = [module.public_alb]
}

# ----------------------------
# Web (Nginx ASG behind Public ALB)  ✅ FIXED
# ----------------------------
module "web_nginx" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//17_web?ref=v1.37.1"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags

  # Network
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_nginx_subnet_ids

  # Public ALB integration
  public_alb_sg_id              = module.public_alb.alb_sg_id
  public_alb_https_listener_arn = module.public_alb.https_listener_arn

  # Golden AMI
  ami_id        = var.nginx_ami_id
  instance_type = var.nginx_instance_type

  # Optional
  key_name                  = var.nginx_key_name
  iam_instance_profile_name = module.iam.instance_profile_name
  # ✅ required for userdata (SSM key injection)
  ansadmin_pubkey_ssm_parameter_name = local.ansadmin_pubkey_ssm_parameter_name

  # Scaling
  desired_capacity = var.nginx_desired_capacity
  min_size         = var.nginx_min_size
  max_size         = var.nginx_max_size

  # Listener rule (host-based)
  enable_listener_rule   = true
  hostnames              = var.nginx_hostnames
  listener_rule_priority = var.nginx_listener_rule_priority

  # App health
  nginx_port        = 80
  health_check_path = "/health"

  nginx_sg_id = module.security.nginx_sg_id
  depends_on  = [module.public_alb, module.acm_public]
}
