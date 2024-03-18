data "aws_ami" "centos8" {
  most_recent = true
  owners      = ["973714476881"]

  filter {
    name   = "name"
    values = ["Centos-8-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/gmd/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "web_sg_id" {
  name = "/gmd/${var.project_name}/${var.environment}/web_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/gmd/${var.project_name}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "web_lb_listener_arn" {
  name = "/gmd/${var.project_name}/${var.environment}/web_lb_listener_arn"
}
