terraform {
  backend "s3" {
    bucket         = "nb-development-tf-remote-state"
    dynamodb_table = "terraform-remote-state-lock"
    key            = "terraform.tfstate"
    encrypt        = true
    region         = "eu-central-1"
  }
}
