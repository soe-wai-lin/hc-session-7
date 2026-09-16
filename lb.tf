################################
###    Dashboard LB         ####
################################
resource "aws_lb" "dashboard_lb" {
  name               = "dashboard-lb"
  load_balancer_type = "application"
  internal           = false
  subnets = [
    aws_subnet.terra_vpc_pub_01.id,
    aws_subnet.terra_vpc_pub_02.id
  ]
  security_groups = [aws_security_group.dashboard-lb-sg.id]
}

resource "aws_lb_listener" "dashboard_lb" {
  load_balancer_arn = aws_lb.dashboard_lb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashboard_tg.arn
  }
}

################################
### Counting LB             ####
################################

resource "aws_lb" "counting_lb" {
  name               = "counting-lb"
  load_balancer_type = "application"
  internal           = true
  subnets = [
    aws_subnet.terra_vpc_priv_01.id,
    aws_subnet.terra_vpc_priv_02.id
  ]
  security_groups = [aws_security_group.counting-lb-sg.id]
}

resource "aws_lb_listener" "counting_lb" {
  load_balancer_arn = aws_lb.counting_lb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.counting_tg.arn
  }
}
