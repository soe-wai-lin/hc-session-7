#######################################
## Counting ASG and Target Group    ###
#######################################

resource "aws_autoscaling_group" "counting_asg" {
  max_size         = var.counting_asg_max
  min_size         = var.counting_asg_min
  desired_capacity = var.counting_asg_desired_capacity
  vpc_zone_identifier = [
    aws_subnet.terra_vpc_priv_01.id,
    aws_subnet.terra_vpc_priv_02.id
  ]
  target_group_arns = [
    aws_lb_target_group.counting_tg.arn
  ]

  launch_template {
    id = aws_launch_template.counting_template.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      instance_warmup = 300
    }
  }

  tag {
    key                 = "Name"
    value               = "counting-server"
    propagate_at_launch = true            ## the tag is automatically applied to EC2 instances launched by the ASG.
  }

  tag {
    key                 = "Environment"
    value               = "Dev"
    propagate_at_launch = true
  }
}

######################################################
## Scaling Policy for counting Scale Out & Scale In ##
######################################################

resource "aws_autoscaling_policy" "counting_cpu_target" {
  name                   = "counting-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.counting_asg.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 30
  }
}

resource "aws_lb_target_group" "counting_tg" {
  name     = "counting-svc-tg"
  port     = var.counting_tg_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.terra_vpc.id
  # Add any other configuration like health checks
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

#########################################
### Dashboard ASG and Target Group  #####
#########################################

resource "aws_autoscaling_group" "dashboard_asg" {
  max_size         = var.dashboard_asg_max
  min_size         = var.dashboard_asg_min
  desired_capacity = var.dashboard_asg_desired_capacity
  vpc_zone_identifier = [
    aws_subnet.terra_vpc_priv_01.id,
    aws_subnet.terra_vpc_priv_02.id
  ]
  target_group_arns = [
    aws_lb_target_group.dashboard_tg.arn
  ]

  launch_template {
    id = aws_launch_template.dashboard_template.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      instance_warmup = 300
    }
  }
  tag {
    key                 = "Name"
    value               = "dashboard-server"
    propagate_at_launch = true            ## the tag is automatically applied to EC2 instances launched by the ASG.
  }

  tag {
    key                 = "Environment"
    value               = "Dev"
    propagate_at_launch = true
  }
  
}

######################################################
## Scaling Policy for dashboard Scale Out & Scale In ##
######################################################

resource "aws_autoscaling_policy" "dashboard_cpu_target" {
  name                   = "dashboard-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.dashboard_asg.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 30
  }
}

resource "aws_lb_target_group" "dashboard_tg" {
  name     = "dashboard-svc-tg"
  port     = var.dashboard_tg_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.terra_vpc.id
  # Add any other configuration like health checks
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
