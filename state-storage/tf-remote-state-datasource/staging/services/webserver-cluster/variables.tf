variable "name" {
  description = "Project slug name."
  type        = string
  default     = "terralearning-remote-state-ex"
}

variable "region" {
  description = "The provider's region."
  type        = string
  default     = "sa-east-1"
}

variable "ami_code" {
  description = "The base image used for the servers."
  type        = string
  default     = "ami-05aa753c043f1dcd3"
}

variable "server_port" {
  description = "The port the server will use to for HTTP requests."
  type        = string
  default     = "8080"
}
