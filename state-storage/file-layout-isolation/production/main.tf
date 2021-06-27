terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "elemos-terralearning-state"
    key    = "file-layout-example/production/terraform.tfstate"
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

resource "aws_instance" "example" {
  ami           = var.ami_code
  instance_type = "t2.micro"
}
