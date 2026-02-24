bucket         = "roboshop-terraform-state-files"
key            = "dev/network/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "roboshop-terraform-lock"
encrypt        = true