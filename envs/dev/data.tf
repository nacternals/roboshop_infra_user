data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

# Read ansadmin public key from SSM (written by bastion bootstrap)
data "aws_ssm_parameter" "ansadmin_pubkey" {
  name = local.ansadmin_pubkey_ssm_parameter_name
}