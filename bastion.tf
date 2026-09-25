resource "aws_instance" "bastion_host" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.terra_vpc_pub_01.id
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  tags = {
    Name = "bastion"
  }
}
resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "ssh access"
  vpc_id      = aws_vpc.terra_vpc.id
  tags = {
    Name = "bastion-sg"
  }
}
resource "aws_security_group_rule" "bastion_allow_ssh" {
  type              = "ingress"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion-sg.id
}

resource "aws_security_group_rule" "bastion_allow_outbond_to_dashboard_sg" {
  type              = "egress"
  to_port           = var.ssh_port
  protocol          = "tcp"
  from_port         = var.ssh_port
  source_security_group_id = aws_security_group.dashboard-sg.id
  security_group_id = aws_security_group.bastion-sg.id
}

resource "aws_security_group_rule" "bastion_https_allow_outbond_to_dashboard_sg" {
  type              = "egress"
  to_port           = var.https_port
  protocol          = "tcp"
  from_port         = var.https_port
  source_security_group_id = aws_security_group.dashboard-sg.id
  security_group_id = aws_security_group.bastion-sg.id
}

resource "aws_security_group_rule" "bastion_allow_outbond_to_counting_sg" {
  type              = "egress"
  to_port           = var.ssh_port
  protocol          = "tcp"
  from_port         = var.ssh_port
  source_security_group_id = aws_security_group.counting-sg.id
  security_group_id = aws_security_group.bastion-sg.id
}

resource "aws_security_group_rule" "bastion_https_allow_outbond_to_counting_sg" {
  type              = "egress"
  to_port           = var.https_port
  protocol          = "tcp"
  from_port         = var.https_port
  source_security_group_id = aws_security_group.counting-sg.id
  security_group_id = aws_security_group.bastion-sg.id
}

resource "aws_security_group_rule" "bastion_allow_to_download_updates" {
  type              = "egress"
  to_port           = var.https_port
  protocol          = "tcp"
  from_port         = var.https_port
  # source_security_group_id = aws_security_group.counting-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion-sg.id
}