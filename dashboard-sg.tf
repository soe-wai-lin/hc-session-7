resource "aws_security_group" "dashboard-sg" {
  name        = "dashboard-sg"
  description = "ssh access"
  vpc_id      = aws_vpc.terra_vpc.id

  tags = {
    Name = "dashboard-sg"
  }
}
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = "tcp"
  source_security_group_id = aws_security_group.bastion-sg.id
  security_group_id = aws_security_group.dashboard-sg.id
}

resource "aws_security_group_rule" "allow_9000" {
  type              = "ingress"
  from_port         = var.dashboard_tg_port
  to_port           = var.dashboard_tg_port
  protocol          = "tcp"
  source_security_group_id = aws_security_group.dashboard-lb-sg.id
  security_group_id = aws_security_group.dashboard-sg.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = var.http_port
  protocol          = "tcp"
  from_port         = var.http_port
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.dashboard-sg.id
}

resource "aws_security_group_rule" "allow_https_outbound_dasboard" {
  type              = "egress"
  to_port           = var.https_port
  protocol          = "tcp"
  from_port         = var.https_port
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.dashboard-sg.id
}

