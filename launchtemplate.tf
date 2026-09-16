data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

################
## Ubuntu AMI ##
################

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

###############################
## dashboard launch_template ##
###############################

resource "aws_launch_template" "dashboard_template" {
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.dashboard-sg.id]


  user_data = base64encode(templatefile("${path.module}/dashboard.sh.tpl", {
    counting_alb_dns = aws_lb.counting_lb.dns_name
  }))

  lifecycle {
    create_before_destroy = true
  }

  update_default_version = true

  key_name = var.key_name

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "dashboard-service"
      Service = "dashboard"
    }
  }

  depends_on = [ aws_lb.counting_lb ]

}


###############################
## counting launch_template ##
###############################

resource "aws_launch_template" "counting_template" {
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type


  vpc_security_group_ids = [aws_security_group.counting-sg.id]


  user_data = base64encode(templatefile("${path.module}/counting.sh", {}))

  lifecycle {
    create_before_destroy = true
  }

  update_default_version = true

  key_name = var.key_name

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "counting-service"
      Service = "counting"
    }
  }

}


