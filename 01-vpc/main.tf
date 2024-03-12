module "roboshop" {
  #source = "../terraform-aws-vpc"
  source       = "git::https://github.com/Gopi1214/terraform-aws-vpc.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  commn_tags   = var.commn_tags
  vpc_tags     = var.vpc_tags

  # public

  public_subnets_cidr = var.public_subnets_cidr

  # private

  private_subnets_cidr = var.private_subnets_cidr

  # database

  database_subnets_cidr = var.database_subnets_cidr

  # peering

  is_vpc_peering_required = var.is_vpc_peering_required
}