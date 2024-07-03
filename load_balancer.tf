resource "aws_lb" "front-tier-lb" {
  name = "front-tier-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.front-tier-sg.id]
  subnets = [aws_subnet.front-tier-sn-1.id,aws_subnet.front-tier-sn-2.id]
  tags = merge(local.tags,{"Name":"front-tier-lb"})
}

resource "aws_alb_listener" "front-tier-lb-lr" {
  load_balancer_arn = aws_lb.front-tier-lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app-tier-tg.arn
  }
}

resource "aws_lb_target_group" "app-tier-tg" {
  name = "app-tier-tg"
  target_type = "instance"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main_vpc.id
  health_check {
    interval            = 30
    path                = "/wp-admin/install.php"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_autoscaling_attachment" "alb_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app-tier-asg.name
  lb_target_group_arn = aws_lb_target_group.app-tier-tg.arn
}


