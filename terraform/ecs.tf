################################################################################
# Task Definition
################################################################################

resource "aws_ecs_task_definition" "app-weather" {
  family                   = var.project_name
  requires_compatibilities = ["EC2"]
  cpu                      = 1024
  memory                   = 1024
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs-task-execution.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = var.project_name
      image     = var.docker_image
      cpu       = 1024
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = tonumber(var.project_port)
          hostPort      = tonumber(var.project_port)
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      repositoryCredentials : {
        "credentialsParameter" : aws_secretsmanager_secret.app-weather-docker-01.arn
      },
    },
  ])
  tags = var.tags
}
