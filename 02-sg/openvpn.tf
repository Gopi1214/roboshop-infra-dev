module "vpn" {
  #source         = "../../terraform-aws-security-group"
  source         = "git::https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_vpc.default.id
  sg_description = "SG for vpn"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
  sg_name = "vpn"
}

# VPN accepting connections from home request passes through that port and receives response on the same port
resource "aws_security_group_rule" "vpn_home" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = module.vpn.sg_id
  cidr_blocks       = ["0.0.0.0/0"] #ideally your home public ip address, it changes frequently
}

resource "aws_security_group_rule" "mongodb_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.mongodb.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "redis_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.redis.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "mysql_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.mysql.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "rabbitmq_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.rabbitmq.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "shipping_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.shipping.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "payment_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.payment.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "cart_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "user_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "web_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.web.sg_id
  source_security_group_id = module.vpn.sg_id
}