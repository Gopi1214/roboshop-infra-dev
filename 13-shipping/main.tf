module "shipping" {
    source = "git::https://github.com/Gopi1214/terraform-roboshop-app.git?ref=main"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    component_sg_id = data.aws_ssm_parameter.shipping_sg_id.value
    iam_instance_profile = var.iam_instance_profile
    environment = var.environment
    project_name = var.project_name
    private_subnet_ids = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
    app_lb_listener_arn = data.aws_ssm_parameter.app_lb_listener_arn.value
    commn_tags = var.commn_tags
    tags = var.tags
    zone_name = var.zone_name
    rule_priority = 50
    app_version          = var.app_version
}