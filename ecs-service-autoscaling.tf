resource "aws_appautoscaling_target" "ecs_playground_app_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.playground_ecs_cluster.name}/${aws_ecs_service.playground_app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on         = [aws_ecs_service.playground_app_service]
}