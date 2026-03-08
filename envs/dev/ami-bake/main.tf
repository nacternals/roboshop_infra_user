module "ami_bake" {
  source = ""

  project              = var.project
  ami_version          = var.ami_version
  common_tags          = local.common_tags
  component_instance_ids = var.component_instance_ids
}