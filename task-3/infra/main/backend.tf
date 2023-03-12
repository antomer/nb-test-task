terraform {
  backend "s3" {
    bucket         = "nb-development-terraform-remote-state"
    dynamodb_table = "nb-development-terraform-remote-state-lock"
    key            = "terraform.tfstate"
    encrypt        = true
    region         = "eu-central-1"
  }
}
