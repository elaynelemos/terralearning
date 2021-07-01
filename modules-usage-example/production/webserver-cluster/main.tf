terraform {
  backend "s3" {
    bucket = "elemos-terralearning-state"
    key    = "modules-usage-example/production/services/webserver-cluser/terraform.tfstate"
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

  cluster_name  = "webservers-module-ex-production"
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 6
}

resource "aws_autoscaling_schedule" "scale_out_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 6
  desired_capacity      = 6
  recurrence            = "0 8 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 6
  desired_capacity      = 2
  recurrence            = "0 17 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}
