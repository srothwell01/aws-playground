resource "aws_ecs_service" "playground_app_service" {
  name                               = "playground_app_service"
  cluster                            = aws_ecs_cluster.playground_ecs_cluster.id
  task_definition                    = "${aws_ecs_task_definition.playground_app.family}:${max("${aws_ecs_task_definition.playground_app.revision}", "${data.aws_ecs_task_definition.playground_app.revision}")}"
  desired_count                      = var.desired_capacity
  deployment_minimum_healthy_percent = "50"
  deployment_maximum_percent         = "100"
  launch_type                        = "FARGATE"
  lifecycle {
    ignore_changes = [task_definition]
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.playground_app_target_group.arn
    container_port   = 80
    container_name   = "playground_app"
  }
  network_configuration {
    security_groups  = [aws_security_group.playground_private_ecs_sg.id]
    subnets          = [aws_subnet.playground_private_sn_01.id]
  }
}