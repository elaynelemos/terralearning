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

variable "server_port" {
  description = "The port the server will use to for HTTP requests."
  type        = number
  default     = 8080
}

variable "ami_code" {
  description = "The base image used for the servers."
  type        = string
  default     = "ami-05aa753c043f1dcd3"
}

locals {
  any_host = ["0.0.0.0/0"]
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the web server."
}

output "clb_dns_name" {
  value = aws_elb.example.dns_name
  description = "The domain name of the load balancer"
}

data "aws_availability_zones" "all" {}

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
    Name = "terraform-hello-world"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-hello-world"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = local.any_host
  }
}

resource "aws_launch_configuration" "example" {
  image_id        = var.ami_code
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "exampe" {
  launch_configuration = aws_launch_configuration.example.id
  availability_zones   = data.aws_availability_zones.all.names

  min_size = 2
  max_size = 4

  load_balancers = [ aws_elb.example.name ]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "elb" {
  name = "terraform-example-elb"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = local.any_host
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = local.any_host
  }
}

resource "aws_elb" "example" {
  name               = "terraform-asg-example"
  security_groups = [aws_security_group.elb.id]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = var.server_port
    instance_protocol = "http"
  }
}
