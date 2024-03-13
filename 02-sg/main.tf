module "vpn" {
  #source         = "../../terraform-aws-security-group"
  source         = "https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_vpc.default.id
  sg_description = "SG for vpn"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
  sg_name = "vpn"
}


module "mongodb" {
  #source         = "../../terraform-aws-security-group"
  source         = "https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for mongodb"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
  sg_name = "mongodb"
}

module "redis" {
  #source         = "../../terraform-aws-security-group"
  source         = "https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for redis"
  sg_name        = "redis"
}

module "rabbitmq" {
  #source         = "../../terraform-aws-security-group"
  source         = "https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for rabbitmq"
  sg_name        = "rabbitmq"
}

module "mysql" {
  #source         = "../../terraform-aws-security-group"
  source         = "https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for mysql"
  sg_name        = "mysql"
}

module "catalogue" {
  #source         = "../../terraform-aws-security-group"
  source         = "https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for catalogue"
  sg_name        = "catalogue"
}

module "cart" {
  #source         = "../../terraform-aws-security-group"
  source         = "https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for cart"
  sg_name        = "cart"
}

module "user" {
  #source         = "../../terraform-aws-security-group"
  source         = "https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for user"
  sg_name        = "user"
}

module "payment" {
  #source         = "../../terraform-aws-security-group"
  source         = "https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for payment"
  sg_name        = "payment"
}

module "shipping" {
  #source         = "../../terraform-aws-security-group"
  source         = "https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for shipping"
  sg_name        = "shipping"
}

module "web" {
  #source         = "../../terraform-aws-security-group"
  source         = "https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for web"
  sg_name        = "web"
}

module "app_alb" {
  #source         = "../../terraform-aws-security-group"
  source         = "https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for app_alb"
  sg_name        = "app_alb"
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

resource "aws_security_group_rule" "mongodb_catalogue" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  security_group_id        = module.mongodb.sg_id
  source_security_group_id = module.catalogue.sg_id
}

resource "aws_security_group_rule" "mongodb_user" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  security_group_id        = module.mongodb.sg_id
  source_security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "redis_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.redis.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "redis_user" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = module.redis.sg_id
  source_security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "redis_cart" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = module.redis.sg_id
  source_security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "mysql_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.mysql.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "mysql_shipping" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.mysql.sg_id
  source_security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "rabbitmq_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.rabbitmq.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "rabbitmq_payment" {
  type                     = "ingress"
  from_port                = 5672
  to_port                  = 5672
  protocol                 = "tcp"
  security_group_id        = module.rabbitmq.sg_id
  source_security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "catalogue_app_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
  source_security_group_id = module.app_alb.sg_id
}


# resource "aws_security_group_rule" "catalogue_cart" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
#   source_security_group_id = module.cart.sg_id
# }

# resource "aws_security_group_rule" "catalogue_web" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
#   source_security_group_id = module.web.sg_id
# }

resource "aws_security_group_rule" "user_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "user_app_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
  source_security_group_id = module.app_alb.sg_id
}


# resource "aws_security_group_rule" "user_web" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
#   source_security_group_id = module.web.sg_id
# }

# resource "aws_security_group_rule" "user_payment" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
#   source_security_group_id = module.payment.sg_id
# }

resource "aws_security_group_rule" "cart_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "cart_app_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
  source_security_group_id = module.app_alb.sg_id
}

# resource "aws_security_group_rule" "cart_web" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.cart.sg_id
#   source_security_group_id = module.web.sg_id
# }

# resource "aws_security_group_rule" "cart_shipping" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.cart.sg_id
#   source_security_group_id = module.shipping.sg_id
# }

# resource "aws_security_group_rule" "cart_payment" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.cart.sg_id
#   source_security_group_id = module.payment.sg_id
# }

resource "aws_security_group_rule" "shipping_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.shipping.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "shipping_app_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.shipping.sg_id
  source_security_group_id = module.app_alb.sg_id
}

# resource "aws_security_group_rule" "shipping_web" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.shipping.sg_id
#   source_security_group_id = module.web.sg_id
# }

resource "aws_security_group_rule" "payment_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.payment.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "payment_app_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.payment.sg_id
  source_security_group_id = module.app_alb.sg_id
}

# resource "aws_security_group_rule" "payment_web" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.payment.sg_id
#   source_security_group_id = module.web.sg_id
# }

resource "aws_security_group_rule" "web_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.web.sg_id
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "web_internet" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = module.web.sg_id
  cidr_blocks       = ["0.0.0.0/0"]
}