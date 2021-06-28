variable "name" {
  description = "Project slug name."
  type        = string
  default     = "terralearning-remote-state-datasource-database"
}

variable "region" {
  description = "The provider's region."
  type        = string
  default     = "sa-east-1"
}
