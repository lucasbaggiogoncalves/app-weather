################################################################################
# Grupos de segurança
################################################################################

########## ECS ##########

module "sg-alb-01" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.2.0"
  name    = "${local.resource-prefix}-alb-01"
  vpc_id  = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = var.ALLOWED_IPS
    }
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.tags
}

module "sg-ecs-ec2-instance-01" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.2.0"
  name    = "${local.resource-prefix}-ecs-ec2-instance-01"
  vpc_id  = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.sg-alb-01.security_group_id
    }
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.tags
}

module "sg-ecs-containers-01" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.2.0"
  name    = "${local.resource-prefix}-ecs-containers-01"
  vpc_id  = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.sg-alb-01.security_group_id
    }
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.tags
}