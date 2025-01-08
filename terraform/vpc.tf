module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.14.0"

  name = "${local.resource-prefix}-vpc-01"

  cidr = var.vpc_cidr

  azs             = var.avaliability_zones
  public_subnets  = var.subnets_cidr.private.public_subnets
  private_subnets = var.subnets_cidr.private.private_subnets

  public_subnet_names  = ["${local.resource-prefix}-subnet-public-1a", "${local.resource-prefix}-subnet-public-1b"]
  private_subnet_names = ["${local.resource-prefix}-subnet-private-1a", "${local.resource-prefix}-subnet-private-1b"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false

  tags = var.tags
  nat_gateway_tags = {
    "Name" = "${local.resource-prefix}-vpc-01-nat-gateway-01"
  }
  igw_tags = {
    "Name" = "${local.resource-prefix}-vpc-01-igw-01"
  }
}