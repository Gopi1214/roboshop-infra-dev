data "aws_ssm_parameter" "vpc_id" {
  name = "/gmd/${var.project_name}/${var.environment}/vpc_id"
}


data "aws_vpc" "default" {
  default = true
}