output "ami_ids" {
  value = module.ami_bake.ami_ids
}

output "ami_ssm_parameters" {
  value = module.ami_bake.ami_ssm_parameters
}