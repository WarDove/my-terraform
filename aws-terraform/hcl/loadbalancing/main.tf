# Loadbalancer Main

resource "aws_lb" "org_alb" {
  name            = "org-app-loadbalancer"
  subnets         = var.public_subnets
  security_groups = var.public_sg
  idle_timeout    = 120
}
