resource "aws_security_group" "counting-sg" {
  name        = "counting-sg"
  description = "ssh access"
  vpc_id      = aws_vpc.terra_vpc.id

  tags = {
    Name = "counting-sg"
  }
}

resource "aws_security_group_rule" "allow__ssh_from_bastion" {
  type                     = "ingress"
  from_port                = var.ssh_port
  to_port                  = var.ssh_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion-sg.id
  security_group_id        = aws_security_group.counting-sg.id
}

resource "aws_security_group_rule" "allow__7777" {
  type                     = "ingress"
  from_port                = var.counting_tg_port
  to_port                  = var.counting_tg_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.counting-lb-sg.id
  security_group_id        = aws_security_group.counting-sg.id
}

resource "aws_security_group_rule" "allow_https_outbound" {
  type              = "egress"
  to_port           = var.https_port
  protocol          = "tcp"
  from_port         = var.https_port
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.counting-sg.id
}

