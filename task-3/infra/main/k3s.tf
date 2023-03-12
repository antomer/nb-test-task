terraform {
  required_providers {
    ssh = {
      source = "loafoe/ssh"
    }
  }
}

locals {
  wait_for_cluster = <<EOT
      timeout=500
      i=0
      while :;do
        [ $timeout -gt 0 ] || exit 1
        kubectl get pod && exit 0
        i=$((i+1))
        sleep 10
        timeout=$((timeout-10))
      done
      exit 1
  EOT
  amis = {
    "eu-central-1" : "ami-0d1ddd83282187d18"
    "eu-west-1" : "ami-06d94a781b544c133"
    "eu-north-1" : "ami-09e1162c87f73958b"
  }
}


resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name   = "${var.env_name}-k3s-host-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "aws_security_group" "k3s" {
  name_prefix = "k3s-sg"
  description = "Security group for k3s"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = var.env_name
  }
}

resource "aws_iam_role" "k3s" {
  name = "${var.env_name}-k3s-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "k3s" {
  name        = "${var.env_name}-k3s-iam-policy"
  path        = "/"
  description = "Policy for role ${var.env_name}-k3s"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "elasticloadbalancing:*"
                ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "k3s" {
  name       = "${var.env_name}-k3s-iam-policy-attachement"
  roles      = [aws_iam_role.k3s.name]
  policy_arn = aws_iam_policy.k3s.arn
}

resource "aws_iam_instance_profile" "k3s" {
  name = "${var.env_name}-k3s-iam-instance-profile"
  role = aws_iam_role.k3s.name
}

module "node" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "${var.env_name}-k3s-instance"
  user_data                   = <<-EOF
              #!/bin/bash
              public_ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
              curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE=true sh -
              k3s server --tls-san "$public_ip" --write-kubeconfig-mode "0644"
              EOF
  ami                         = local.amis[var.aws_region]
  instance_type               = var.k3s_instance_type
  key_name                    = aws_key_pair.ssh.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.k3s.name
  vpc_security_group_ids      = [aws_security_group.k3s.id]

  tags = {
    Name = "${var.env_name}-k3s-instance"
  }
}

resource "null_resource" "wait_for_k3s" {
  provisioner "remote-exec" {
    inline = [local.wait_for_cluster]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh.private_key_pem
    host        = module.node.public_ip
  }
}


resource "ssh_resource" "kubeconfig" {
  host        = module.node.public_ip
  user        = "ubuntu"
  private_key = tls_private_key.ssh.private_key_pem

  timeout = "30s"

  commands = [
    "kubectl config view --minify --flatten | sed -e 's|server: https://.*:|server: https://${module.node.public_ip}:|'",
  ]

  depends_on = [null_resource.wait_for_k3s, module.node]
}
