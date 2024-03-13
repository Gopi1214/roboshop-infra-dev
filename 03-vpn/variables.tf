variable "project_name" {
  type    = string
  default = "roboshop"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "commn_tags" {
  default = {
    project     = "roboshop"
    environment = "dev"
    terraform   = true
  }
}