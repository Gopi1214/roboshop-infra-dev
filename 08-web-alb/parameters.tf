resource "aws_ssm_parameter" "web_lb_listener_arn" {
  name  = "/gmd/${var.project_name}/${var.environment}/web_lb_listener_arn"
  type  = "String"
  value = aws_lb_listener.https.arn
}

