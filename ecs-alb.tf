
resource "aws_alb" "playground_alb_load_balancer" {
  name            = "playground-ecs-alb-load-balancer"
  security_groups = [aws_security_group.playground_public_sg.id]
  subnets         = [aws_subnet.playground_public_sn_01.id, aws_subnet.playground_public_sn_02.id]
  tags = {
    Name        = "playground-alb-load-balancer"
    Description = "Load balancer to support the ECS cluster"
  }
}

resource "aws_alb_target_group" "playground_app_target_group" {
  name        = "playground-app-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.playground_vpc.id
  target_type = "ip"
  depends_on  = [aws_alb.playground_alb_load_balancer]
  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags = {
    Name = "playground-app-target-group"
  }
}

resource "aws_alb_listener" "alb-listener-https" {
  load_balancer_arn = aws_alb.playground_alb_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.rothwell-dev-cert-validation.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.playground_app_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "alb-listener-http" {
  load_balancer_arn = aws_alb.playground_alb_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.playground_app_target_group.arn
    type             = "forward"
  }
}