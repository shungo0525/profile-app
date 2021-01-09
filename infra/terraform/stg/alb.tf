resource "aws_lb" "for_api_server" {
  name               = "${var.app_name}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    module.for_alb.security_group_id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id,
  ]
}

resource "aws_lb_listener" "for_api_server" {
  load_balancer_arn = aws_lb.for_api_server.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.for_api_server.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.for_api_server.arn
  certificate_arn = aws_acm_certificate.main.arn
  port     = "443"
  protocol = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.for_api_server.id
  }
}

resource "aws_lb_listener_rule" "http_to_https" {
  listener_arn = aws_lb_listener.for_api_server.arn

  priority = 99

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    field  = "host-header"
    values = [var.domain]
  }
}

resource "aws_lb_target_group" "for_api_server" {
  name     = "${var.app_name}-lb-tg-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  // TODO: 修正必須
  health_check {
    path = "/index.html"
  }
}

resource "aws_lb_target_group_attachment" "for_api_server_a" {
  target_group_arn = aws_lb_target_group.for_api_server.arn
  target_id        = aws_instance.a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "for_api_server_c" {
  target_group_arn = aws_lb_target_group.for_api_server.arn
  target_id        = aws_instance.c.id
  port             = 80
}

module "for_alb" {
  source      = "../modules/security_group"
  name        = "alb"
  vpc_id      = aws_vpc.main.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_https" {
  security_group_id = module.for_alb.security_group_id

  type = "ingress"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}
