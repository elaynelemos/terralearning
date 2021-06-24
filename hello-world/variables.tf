variable "name" {
  type        = string
  default     = "terralearning-hello-world"
  description = "Project slug name."
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
