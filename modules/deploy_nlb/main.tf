resource "aws_lb_target_group" "tg_for_nlb_80" {
  name        = "target-group-80"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  health_check {
    protocol = "TCP"
  }  
  tags = {
    Name = "target_group_${var.my_name}"
  }  
}

resource "aws_lb_target_group" "tg_for_nlb_443" {
  name        = "target-group-443"
  port        = 443
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  health_check {
    protocol = "TCP"
  }  
  tags = {
    Name = "target_group_${var.my_name}"
  }  
}

resource "aws_lb_target_group_attachment" "attach_instance_to_tg_80" {
  count            = var.nm_worker
  target_group_arn = aws_lb_target_group.tg_for_nlb_80.arn
  target_id        = var.workers_id[count.index] //with pod ingress controller
  port             = 80
} 

resource "aws_lb_target_group_attachment" "attach_instance_to_tg_443" {
  count            = var.nm_worker
  target_group_arn = aws_lb_target_group.tg_for_nlb_443.arn
  target_id        = var.workers_id[count.index] //with pod ingress controller
  port             = 443
} 

resource "aws_lb" "nlb" {
  name               = "nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [var.sg_id]
  subnets            = [var.subnet_id[0]]
  tags = {
    Name = "nlb_${var.my_name}"
  }
}

resource "aws_lb_listener" "nlb_tg_80" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_for_nlb_80.arn
  } 
}

resource "aws_lb_listener" "nlb_tg_443" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_for_nlb_443.arn
  }
}

#resource "aws_acm_certificate" "clb_cert" {
#  domain_name       = "nginx.fatherfedor.shop"
#  validation_method = "DNS"
#  validation_option {
#    domain_name       = "nginx.fatherfedor.shop"
#    validation_domain = "fatherfedor.shop"
#  }
#  tags = {
#    Name = "acm_certificate_${var.my_name}"
#  }
#}

#resource "aws_elb" "nlb" {
#  name            = "clb"
#  internal        = false
#  security_groups = [aws_security_group.sg.id]
#  subnets         = [var.subnet_id[0]]
#  listener {
#    instance_port     = 80
#    instance_protocol = "http"
#    lb_port           = 80
#    lb_protocol       = "http"
#  }
#
#  #listener {
#  #  instance_port      = 80
#  #  instance_protocol  = "http"
#  #  lb_port            = 443
#  #  lb_protocol        = "https"
#  #  ssl_certificate_id = 
#  #}
#  tags = {
#    Name = "clb_${var.my_name}"
#  }
#}
#
#resource "aws_elb_attachment" "attach_instance" {
#  count         = var.nm_worker
#  elb      = aws_elb.nlb.id
#  instance = aws_instance.instance_workers[count.index].id
#}