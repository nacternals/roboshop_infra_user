data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

# NOTE:
# We are using module "acm_public" to CREATE + VALIDATE the ACM cert.
# So we do NOT need any data.aws_acm_certificate lookup here.