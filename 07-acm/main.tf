resource "aws_acm_certificate" "pjdevops" {
  domain_name       = "*.pjdevops.online"
  validation_method = "DNS"

  tags = merge(
    var.commn_tags,
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "pjdevops" {
  for_each = {
    for dvo in aws_acm_certificate.pjdevops.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 1
  type            = each.value.type
  zone_id         = data.aws_route53_zone.pjdevops.zone_id
}

resource "aws_acm_certificate_validation" "pjdevops" {
  certificate_arn         = aws_acm_certificate.pjdevops.arn
  validation_record_fqdns = [for record in aws_route53_record.pjdevops : record.fqdn]
}