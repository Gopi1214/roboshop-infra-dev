data "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/gmd/${var.project_name}/${var.environment}/acm_certificate_arn"
}

data "aws_ssm_parameter" "web_lb_listener_arn" {
  name = "/gmd/${var.project_name}/${var.environment}/web_lb_listener_arn"
}

data "aws_cloudfront_cache_policy" "cache" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "no_cache" {
  name = "Managed-CachingDisabled"
}