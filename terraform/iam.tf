################################################################################
# ECS
################################################################################

########## ECS Task Execution Role ##########

resource "aws_iam_policy" "ecs-secrets-manager" {
  name        = "ecsSecretsManagerAccess"
  path        = "/"
  description = "Allow ECS to access AWS Secrets Manager"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "secretsmanager:GetSecretValue"
        ],
        Resource : [
          aws_secretsmanager_secret.app-weather-docker-01.arn
        ]
      }
    ]
  })
  tags = var.tags

  depends_on = [aws_secretsmanager_secret.app-weather-docker-01]
}

resource "aws_iam_role" "ecs-task-execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs-secrets-manager" {
  role       = aws_iam_role.ecs-task-execution.name
  policy_arn = aws_iam_policy.ecs-secrets-manager.arn
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution" {
  role       = aws_iam_role.ecs-task-execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}