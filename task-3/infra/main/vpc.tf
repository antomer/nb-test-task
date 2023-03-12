module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  name    = "${var.env_name}-vpc"
  cidr    = var.vpc_cidr

  azs             = ["${var.aws_region}a"]
  private_subnets = []
  public_subnets  = [var.public_subnet]

  enable_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = var.env_name
  }
}