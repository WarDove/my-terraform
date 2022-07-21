# elb outputs

output "alb_main_tg_arn" {
  value = aws_lb_target_group.main.arn
}
