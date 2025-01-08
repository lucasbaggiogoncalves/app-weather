resource "aws_secretsmanager_secret" "app-weather-docker-01" {
  name        = "${local.resource-prefix}-secret-docker-06"
  description = "Secret for docker credentials"

  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "app-weather-docker-01" {
  secret_id     = aws_secretsmanager_secret.app-weather-docker-01.id
  secret_string = jsonencode(var.DOCKER_HUB_USER_PASS)
}
