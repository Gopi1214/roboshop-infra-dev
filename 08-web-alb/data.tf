data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "/gmd/${var.project_name}/${var.environment}/web_alb_sg_id"
}

data "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/gmd/${var.project_name}/${var.environment}/acm_certificate_arn"
}

### private_subnet_ids

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/gmd/${var.project_name}/${var.environment}/private_subnet_ids"
}

