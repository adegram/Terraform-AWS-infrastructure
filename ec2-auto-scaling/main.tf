resource "aws_security_group" "alb" {

  name_prefix = "portfolio-alb-"
  description = "HTTPS endpoint restricted to the trusted client CIDR"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.trusted_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags

}
resource "aws_security_group" "web" {

  name_prefix = "portfolio-web-"
  description = "Application ingress only from ALB"
  vpc_id      = var.vpc_id
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags

}
resource "aws_lb" "web" {

  name               = "portfolio-asg-web"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.alb.id]
  tags               = var.tags

}
resource "aws_lb_target_group" "web" {

  name        = "portfolio-asg-web"
  vpc_id      = var.vpc_id
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  health_check {
    path    = "/healthz"
    matcher = "200-399"
  }
  tags = var.tags

}
resource "aws_lb_listener" "https" {

  load_balancer_arn = aws_lb.web.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

}
resource "aws_launch_template" "web" {

  name_prefix            = "portfolio-web-"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data = base64encode(<<-USERDATA
    #!/bin/bash
    dnf install -y python3
    mkdir -p /opt/web
    echo 'This is a demo app that exposes healthz endpoint' > /opt/web/index.html
    echo 'ok' > /opt/web/healthz
    cd /opt/web && nohup python3 -m http.server 8080 >/var/log/web.log 2>&1 &
  USERDATA
  )
  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }
  block_device_mappings {

    device_name = "/dev/xvda"
    ebs {
      volume_size           = 10
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }

  }
  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = "portfolio-asg-instance" })
  }

}
resource "aws_autoscaling_group" "web" {

  name                = "portfolio-web-asg"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = [aws_lb_target_group.web.arn]
  health_check_type   = "ELB"
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "portfolio-web"
    propagate_at_launch = true
  }

}
resource "aws_autoscaling_policy" "cpu" {

  name                   = "target-cpu-50"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50

  }

}
