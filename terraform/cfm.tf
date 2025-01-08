################################################################################
# Deploy dos seguintes serviços acontecem via essa template:
# ECS Cluster
# EC2 Launch Template
# EC2 Auto Scaling Group
# IAM Roles dependentes
################################################################################

resource "aws_cloudformation_stack" "app-weather-ecs-cluster" {
  name = "${local.resource-prefix}-ecs-cluster-stack"

  parameters = {
    ECSClusterName                = "${local.resource-prefix}-ecs-cluster-01"
    SecurityGroupIds              = module.sg-ecs-ec2-instance-01.security_group_id
    IamRoleInstanceProfile        = "arn:aws:iam::${var.AWS_ACCOUNT_ID}:instance-profile/ecsInstanceRole"
    VpcId                         = module.vpc.vpc_id
    SubnetIds                     = module.vpc.private_subnets[0]
    ECSLaunchTemplateInstanceType = var.ecs_cluster.instance_type
    ECSAutoScalingMinSize         = var.ecs_cluster.minimum_size
    ECSAutoScalingMaxSize         = var.ecs_cluster.maximum_size
    ECSAutoScalingDesiredSize     = var.ecs_cluster.desired_capacity
  }
  template_body = file("${var.cloud_formation_path.ecs_cluster}")

  depends_on = [module.vpc]

  tags = var.tags
}

# ###############################################################################
# Deploy dos seguintes serviços acontecem via essa template:
# ECS Service
# EC2 Load Balancer
# EC2 Target Group
# ###############################################################################

resource "aws_cloudformation_stack" "app-weather-ecs-service" {
  name = "${local.resource-prefix}-ecs-service-stack"

  parameters = {
    ECSClusterName               = "${local.resource-prefix}-ecs-cluster-01"
    ECSServiceName               = "${local.resource-prefix}-ecs-svc-01"
    LoadBalancerName             = "${local.resource-prefix}-ecs-lb-01"
    TargetGroupName              = "${local.resource-prefix}-ecs-tg-01"
    LoadBalancerSecurityGroupIDs = module.sg-alb-01.security_group_id
    ContainersSecurityGroupIDs   = module.sg-ecs-containers-01.security_group_id
    TaskDefinition               = aws_ecs_task_definition.app-weather.arn
    ContainerName                = var.project_name
    ContainerPort                = var.project_port
    VpcID                        = module.vpc.vpc_id
    SubnetIDs                    = "${join(",", [module.vpc.public_subnets[0], module.vpc.public_subnets[1]])}"
  }
  template_body = file("${var.cloud_formation_path.ecs_service}")

  tags = var.tags

  depends_on = [aws_cloudformation_stack.app-weather-ecs-cluster]
}