module "ami_bake" {
  source = "../../../../roboshop_terraform_modules/21_ami-bake"

  project                = var.project
  environment            = var.environment
  ami_version            = var.ami_version
  build_date             = var.build_date
  common_tags            = local.common_tags
  component_instance_ids = var.component_instance_ids
  component_tiers        = local.component_tiers

}
