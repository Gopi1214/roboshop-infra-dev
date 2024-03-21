data "aws_ssm_parameter" "vpc_id" {
    name = "/gmd/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "payment_sg_id" {
    name = "/gmd/${var.project_name}/${var.environment}/payment_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
    name = "/gmd/${var.project_name}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "app_lb_listener_arn" {
    name = "/gmd/${var.project_name}/${var.environment}/app_lb_listener_arn"
}