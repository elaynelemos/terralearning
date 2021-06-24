terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.45"
    }
  }
}

provider "aws" {
  alias  = "sa_east_1"
  region = "sa-east-1"
}

locals {
  any_host = ["0.0.0.0/0"]
}

resource "aws_security_group" "instance" {
  name = var.name

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = local.any_host
  }
}

resource "aws_instance" "example" {
  ami                    = var.ami_code
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  tags = {
    Name = var.name
  }
}
