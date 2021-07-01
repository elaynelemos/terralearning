provider "aws" {
  region = "sa-east-1"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name = "webservers-module-ex-staging"
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}
