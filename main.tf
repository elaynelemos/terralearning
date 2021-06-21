terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.45"
    }
  }
}

variable "server_port" {
  description = "The port the server will use to for HTTP requests."
  type        = number
  default     = 8080
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the web server."
}

provider "aws" {
  alias  = "sa_east_1"
  region = "sa-east-1"
}

resource "aws_instance" "example" {
  ami                    = "ami-05aa753c043f1dcd3"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  tags = {
    Name = "terraform-hello-world"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-hello-world"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
