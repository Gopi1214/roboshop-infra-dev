variable "cidr_block" {
  default = "10.0.0.0/16"
  type    = string
}

variable "commn_tags" {
  type = map(any)
  default = {
    project     = "roboshop"
    environment = "dev"
    terraform   = true
  }
}

variable "vpc_tags" {
  default = {}
}

variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "public_subnets_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnets_cidr" {
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "is_vpc_peering_required" {
  type    = bool
  default = true
}