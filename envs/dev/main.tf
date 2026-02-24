module "network" {
  source = "git::ssh://git@github.com/nacternals/roboshop_terraform_modules.git//network?ref=v1.0.0"


  project                    = var.project
  environment                = var.environment
  vpc_cidr                   = var.vpc_cidr
  azs                        = var.azs
  public_subnet_cidrs        = var.public_subnet_cidrs
  private_nginx_subnet_cidrs = var.private_nginx_subnet_cidrs
  private_app_subnet_cidrs   = var.private_app_subnet_cidrs
  private_db_subnet_cidrs    = var.private_db_subnet_cidrs
}




# locals {
#   name_prefix = "${var.project}-${var.environment}"
# }

# module "network" {
#   source = "../../modules/network"

#   project                   = var.project
#   environment               = var.environment
#   vpc_cidr                  = var.vpc_cidr
#   azs                       = var.azs
#   public_subnet_cidrs        = var.public_subnet_cidrs
#   private_nginx_subnet_cidrs = var.private_nginx_subnet_cidrs
#   private_app_subnet_cidrs   = var.private_app_subnet_cidrs
#   private_db_subnet_cidrs    = var.private_db_subnet_cidrs
# }

# module "security" {
#   source = "../../modules/security"

#   vpc_id      = module.network.vpc_id
#   project     = var.project
#   environment = var.environment
#   name_prefix = local.name_prefix

#   my_ip_cidr = var.my_ip_cidr
#   app_port   = var.app_port
# }

# module "iam" {
#   source = "../../modules/iam"
#   project     = var.project
#   environment = var.environment
# }

# module "bastion" {
#   source = "../../modules/bastion"

#   project     = var.project
#   environment = var.environment

#   ami_id                = var.dev_bastion_ami_id
#   instance_type         = var.dev_bastion_instance_type
#   key_name              = var.dev_bastion_key_name
#   subnet_id             = module.network.public_subnet_ids[0]
#   sg_id                 = module.security.sg_bastion_id
#   instance_profile_name = module.iam.instance_profile_name
# }

# module "db" {
#   source = "../../modules/db-ec2"

#   project     = var.project
#   environment = var.environment

#   db_ami_id              = var.db_tier_ami_id
#   instance_type          = var.db_tier_instance_type
#   key_name               = var.db_tier_ec2_key_name
#   private_db_subnet_ids  = module.network.private_db_subnet_ids
#   instance_profile_name  = module.iam.instance_profile_name
#   ansadmin_public_key    = var.db_tier_ansadmin_public_key

#   mongodb_sg_id  = module.security.sg_mongodb_id
#   mysql_sg_id    = module.security.sg_mysql_id
#   redis_sg_id    = module.security.sg_redis_id
#   rabbitmq_sg_id = module.security.sg_rabbitmq_id
# }

# module "private_dns" {
#   source = "../../modules/private-dns"

#   zone_name = "dev.optimusprime.uno"
#   vpc_id    = module.network.vpc_id

#   records = {
#     mongodb  = module.db.mongodb_private_ip
#     mysql    = module.db.mysql_private_ip
#     redis    = module.db.redis_private_ip
#     rabbitmq = module.db.rabbitmq_private_ip
#   }

#   project     = var.project
#   environment = var.environment
# }

# module "app" {
#   source = "../../modules/app-alb-asg"

#   project     = var.project
#   environment = var.environment
#   name_prefix = local.name_prefix

#   vpc_id                = module.network.vpc_id
#   private_app_subnet_ids = module.network.private_app_subnet_ids

#   alb_internal_sg_id = module.security.sg_alb_internal_id
#   app_sg_id          = module.security.sg_app_id

#   instance_profile_name = module.iam.instance_profile_name

#   app_services               = var.app_services
#   app_port                   = var.app_port
#   app_health_check_path      = var.app_health_check_path
#   app_tier_key_name          = var.app_tier_key_name
#   app_tier_ami_id            = var.app_tier_ami_id
#   app_instance_type_by_service = var.app_instance_type_by_service

#   app_asg_min_by_service     = var.app_asg_min_by_service
#   app_asg_desired_by_service = var.app_asg_desired_by_service
#   app_asg_max_by_service     = var.app_asg_max_by_service

#   ansadmin_public_key = var.app_tier_ansadmin_public_key
# }

# data "aws_route53_zone" "public" {
#   name         = var.public_zone_name
#   private_zone = false
# }

# module "acm" {
#   source = "../../modules/acm-public"

#   public_tls_domain = var.public_tls_domain
#   public_zone_id    = data.aws_route53_zone.public.zone_id

#   project     = var.project
#   environment = var.environment
# }

# module "web" {
#   source = "../../modules/web-alb-nginx"

#   project     = var.project
#   environment = var.environment
#   name_prefix = local.name_prefix

#   vpc_id                 = module.network.vpc_id
#   public_subnet_ids       = module.network.public_subnet_ids
#   private_nginx_subnet_ids = module.network.private_nginx_subnet_ids

#   alb_public_sg_id = module.security.sg_alb_public_id
#   nginx_sg_id      = module.security.sg_nginx_id

#   instance_profile_name = module.iam.instance_profile_name

#   certificate_arn = module.acm.certificate_arn

#   nginx_ami_id            = var.nginx_ami_id
#   nginx_instance_type     = var.nginx_instance_type
#   nginx_root_volume_size  = var.nginx_root_volume_size

#   app_tier_key_name         = var.app_tier_key_name
#   nginx_ansadmin_public_key = var.nginx_ansadmin_public_key
# }

# module "public_dns" {
#   source = "../../modules/public-dns"

#   public_zone_id = data.aws_route53_zone.public.zone_id
#   record_name    = var.public_record_name

#   alb_dns_name = module.web.public_alb_dns_name
#   alb_zone_id  = module.web.public_alb_zone_id
# }
