resource "aws_security_group" "dashboard-lb-sg" {
  name        = "dashboard-lb-sg"
  description = "dashboard-lb-sg"
  vpc_id      = aws_vpc.terra_vpc.id

  tags = {
    Name = "dashboard-lb-sg"
  }
}
resource "aws_security_group_rule" "allow_http_from_internet" {
  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.dashboard-lb-sg.id
}

resource "aws_security_group_rule" "allow_https_from_internet" {
  type              = "ingress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.dashboard-lb-sg.id
}

resource "aws_security_group_rule" "allow_to_dashboard_sg" {
  type              = "egress"
  to_port           = var.dashboard_tg_port
  protocol          = "tcp"
  from_port         = var.dashboard_tg_port
  source_security_group_id = aws_security_group.dashboard-sg.id
  security_group_id = aws_security_group.dashboard-lb-sg.id
}
