terraform {
  backend "s3" {
    bucket = "elemos-terralearning-state"
    key    = "modules-usage-example/staging/services/webserver-cluser/terraform.tfstate"
    region = "sa-east-1"

    dynamodb_table = "elemos-terralearning-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "sa-east-1"
}

module "webserver_cluster" {
  source = "github.com/elaynelemos/terralearning-modules//services//webserver-cluster?ref=v0.0.2"

  cluster_name  = "webservers-module-ex-staging"
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}
