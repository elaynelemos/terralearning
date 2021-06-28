terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "elemos-terralearning-state"
    key    = "tf-remote-state-example/staging/services/webserver-cluster/terraform.tfstate"
    region = "sa-east-1"

    dynamodb_table = "elemos-terralearning-state-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.45"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  any_host = ["0.0.0.0/0"]
}

data "aws_availability_zones" "all" {}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "elemos-terralearning-state"
    key    = "tf-remote-state-example/staging/databases/mysql/terraform.tfstate"
    region = var.region
  }
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

resource "aws_launch_configuration" "example" {
  image_id        = var.ami_code
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  user_data       = <<-EOF
              #!/bin/bash
              db_address="${data.terraform_remote_state.db.outputs.address}"
              db_port="${data.terraform_remote_state.db.outputs.port}"
              echo "Hello, World! DB is at $db_address:$db_port" > index.html
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

  load_balancers    = [aws_elb.example.name]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}

resource "aws_security_group" "elb" {
  name = "terralearning-example-elb"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = local.any_host
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.any_host
  }
}

resource "aws_elb" "example" {
  name               = var.name
  security_groups    = [aws_security_group.elb.id]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}
