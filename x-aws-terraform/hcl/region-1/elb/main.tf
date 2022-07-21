# elb main

resource "aws_lb" "main" {
  name                       = "main-http"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.sg_map["public"].id[*]
  subnets                    = var.subnets["public"][*].id
  enable_deletion_protection = false
  idle_timeout               = 120

  tags = {
    Name = "main-http"
  }
}

resource "aws_lb_target_group" "main" {
  name        = "main-http"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    interval            = var.interval
    timeout             = var.timeout
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}




