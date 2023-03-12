variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "env_name" {
  description = "Environment name"
  type        = string
  default     = "nb-development"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet" {
  description = "Public subnet CIDR block"
  type        = string
  default     = "10.0.101.0/24"
}

variable "k3s_instance_type" {
  description = "EC2 instance type to be used to provision k3s node"
  type        = string
  default     = "t3.micro"
}