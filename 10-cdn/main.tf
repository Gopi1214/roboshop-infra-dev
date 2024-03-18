#creating Cloudfront distribution :
resource "aws_cloudfront_distribution" "pjdevops" {
  enabled             = true
  aliases             = ["web-${var.environment}.${var.zone_name}"]
  origin {
    domain_name = "web-${var.environment}.${var.zone_name}"
    origin_id   = "web-${var.environment}.${var.zone_name}"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "web-${var.environment}.${var.zone_name}"
    viewer_protocol_policy = "https-only"
    forwarded_values {
      headers      = []
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "US", "CA"]
    }
  }
  tags = merge (
         var.commn_tags,
         var.tags
  )
  viewer_certificate {
    acm_certificate_arn      = data.aws_ssm_parameter.acm_certificate_arn.value
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}

# creating A record for domain:
  module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name = "web-cdn"
      type = "A"
      alias = {
        name    = aws_cloudfront_distribution.pjdevops.domain_name
        zone_id = aws_cloudfront_distribution.pjdevops.hosted_zone_id
      }
    }
  ]
}