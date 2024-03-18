variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "commn_tags" {
  default = {
    project     = "roboshop"
    environment = "dev"
    terraform   = true
  }
}

variable "tags" {
  default = {
    Component = "web-alb"
  }
}

variable "zone_name" {
  default = "pjdevops.online"
}

