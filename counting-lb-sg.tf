resource "aws_security_group" "counting-lb-sg" {
  name        = "counting-lb-sg"
  description = "counting-lb-sg"
  vpc_id      = aws_vpc.terra_vpc.id

  tags = {
    Name = "counting-lb-sg"
  }
}
resource "aws_security_group_rule" "allow_http_from_dashboard_sg" {
  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  source_security_group_id = aws_security_group.dashboard-sg.id
  security_group_id = aws_security_group.counting-lb-sg.id
}

resource "aws_security_group_rule" "allow_https_from_dashboard_sg" {
  type              = "ingress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  source_security_group_id = aws_security_group.dashboard-sg.id
  security_group_id = aws_security_group.counting-lb-sg.id
}

resource "aws_security_group_rule" "allow_to_counting_sg" {
  type              = "egress"
  to_port           = var.counting_tg_port
  protocol          = "tcp"
  from_port         = var.counting_tg_port
  source_security_group_id = aws_security_group.counting-sg.id
  security_group_id = aws_security_group.counting-lb-sg.id
}
