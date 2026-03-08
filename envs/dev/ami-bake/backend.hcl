bucket         = "roboshop-terraform-state-files"
key            = "/dev/ami-bake/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "roboshop-terraform-lock-files"
encrypt        = true