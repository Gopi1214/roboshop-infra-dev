### app_alb security group

data "aws_ssm_parameter" "app_alb_sg_id" {
  name = "/gmd/${var.project_name}/${var.environment}/app_alb_sg_id"
}

### private_subnet_ids

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/gmd/${var.project_name}/${var.environment}/private_subnet_ids"
}