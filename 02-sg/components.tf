module "mongodb" {
  #source         = "../../terraform-aws-security-group"
  source         = "git::https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for mongodb"
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
  sg_name = "mongodb"
}

module "redis" {
  #source         = "../../terraform-aws-security-group"
  source         = "git::https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for redis"
  sg_name        = "redis"
}

module "rabbitmq" {
  #source         = "../../terraform-aws-security-group"
  source         = "git::https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for rabbitmq"
  sg_name        = "rabbitmq"
}

module "mysql" {
  #source         = "../../terraform-aws-security-group"
  source         = "git::https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for mysql"
  sg_name        = "mysql"
}

module "catalogue" {
  #source         = "../../terraform-aws-security-group"
  source         = "git::https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for catalogue"
  sg_name        = "catalogue"
}

module "cart" {
  #source         = "../../terraform-aws-security-group"
  source         = "git::https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for cart"
  sg_name        = "cart"
}

module "user" {
  #source         = "../../terraform-aws-security-group"
  source         = "git::https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for user"
  sg_name        = "user"
}

module "payment" {
  #source         = "../../terraform-aws-security-group"
  source         = "git::https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for payment"
  sg_name        = "payment"
}

module "shipping" {
  #source         = "../../terraform-aws-security-group"
  source         = "git::https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for shipping"
  sg_name        = "shipping"
}

module "web" {
  #source         = "../../terraform-aws-security-group"
  source         = "git::https://github.com/Gopi1214/terraform-aws-security-group.git"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  sg_description = "SG for web"
  sg_name        = "web"
}


# This is just for testing purpose
resource "aws_security_group_rule" "catalogue_vpn_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
  source_security_group_id = module.vpn.sg_id
}

# resource "aws_security_group_rule" "payment_web" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.payment.sg_id
#   source_security_group_id = module.web.sg_id
# }

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

# resource "aws_security_group_rule" "shipping_web" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.shipping.sg_id
#   source_security_group_id = module.web.sg_id
# }

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