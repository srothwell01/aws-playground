data "aws_ecs_task_definition" "playground_app" {
  task_definition = aws_ecs_task_definition.playground_app.family
  depends_on      = [aws_ecs_task_definition.playground_app]
}

resource "aws_ecs_task_definition" "playground_app" {
  family                   = "playground_app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.playground-task-execution-role.arn
  cpu                      = 256
  memory                   = 1024
  container_definitions    = <<DEFINITION
  [
    {
      "name": "playground_app",
      "image": "nginx:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "protocol": "tcp",
          "hostPort": 80
        }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "playground_app",
            "awslogs-region": "eu-west-2",
            "awslogs-stream-prefix": "ecs"
          }
      },
      "memory": 1024,
      "cpu": 256
    }
  ]
  DEFINITION
}