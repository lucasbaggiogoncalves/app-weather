################################################################################
# Secrets
################################################################################

variable "AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type      = string
  sensitive = true
}

variable "AWS_ACCOUNT_ID" {
  type      = string
  sensitive = true
}

variable "DOCKER_HUB_USER_PASS" {
  type      = map(string)
  sensitive = true
}

variable "ALLOWED_IPS" {
  type    = string
  sensitive = true
}

################################################################################
# Ambiente
################################################################################

variable "region" {
  type = map(string)
  default = {
    "code"   = "us-east-1"
    "prefix" = "use1"
  }
}

variable "environment" {
  type    = string
  default = "prd"
}

variable "tags" {
  type = map(string)
  default = {
    "Terraform"   = "true"
    "Environment" = "prd"
  }
}

################################################################################
# Definições do projeto
################################################################################

variable "project_name" {
  type    = string
  default = "app-weather"
}

variable "project_port" {
  type    = string
  default = 3000
}

variable "docker_image" {
  type    = string
  default = "lucasbaggio/app-weather:latest"
}

################################################################################
# Definições dos recursos
################################################################################

########## VPC ##########

variable "vpc_cidr" {
  type    = string
  default = "10.77.0.0/16"
}

variable "avaliability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "subnets_cidr" {
  type = map(map(list(string)))
  default = {
    "private" = {
      "public_subnets"  = ["10.77.100.0/24", "10.77.101.0/24"]
      "private_subnets" = ["10.77.50.0/24", "10.77.51.0/24"]
    }
  }
}

########## ECS ##########

variable "ecs_cluster" {
  type = map(string)
  default = {
    "instance_type"    = "t3.medium"
    "minimum_size"     = 1
    "maximum_size"     = 1
    "desired_capacity" = 1
  }
}

########## CFM ##########

variable "cloud_formation_path" {
  type = map(string)
  default = {
    "ecs_cluster" = "./cloud-formation/ecs-cluster-stack.yml"
    "ecs_service" = "./cloud-formation/ecs-service-stack.yml"
  }
}