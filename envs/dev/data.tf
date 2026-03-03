data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

# Only needed if THIS layer is creating/attaching listener certs.
# If public ALB module already handles certs, skip this.
data "aws_acm_certificate" "dev_cert" {
  domain      = "dev.optimusprime.uno"
  statuses    = ["ISSUED"]
  most_recent = true
}