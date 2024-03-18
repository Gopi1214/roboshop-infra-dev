data "aws_route53_zone" "pjdevops" {
  name         = "pjdevops.online"
  private_zone = false
}