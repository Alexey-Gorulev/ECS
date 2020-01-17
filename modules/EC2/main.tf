data "aws_ami" "latest_ami_for_ECS" {
  owners      = ["591542846629"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"]
  }
}

locals {
  env_project = "${var.environment}_${var.project}"
}

resource "aws_autoscaling_group" "project" {
  name                 = "asg_${var.locals.env_project}"
  max_size             = "${var.asg_max_size}"
  min_size             = "${var.asg_min_size}"
  desired_capacity     = "${var.asg_desired_capacity}"
  vpc_zone_identifier  = "${var.public_subnet_ids}"
  launch_configuration = aws_launch_configuration.project.name
  health_check_type    = "ELB"

  tags = [
    {
      key                 = "Environment"
      value               = "${var.env}_asg"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "${var.project}_asg"
      propagate_at_launch = true
    },
    {
      key                 = "Sub_project"
      value               = "${var.sub_project}_asg"
      propagate_at_launch = true
    },
  ]
}

/*
resource "aws_autoscaling_policy" "CPU-TEST-ScaleUP" {
  name = "ScaleUP"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.project.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarmUP" {
  alarm_name = "TEST-CPU(UP)"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "85" dimensions { AutoScalingGroupName = "${aws_autoscaling_group.project.name}"
}
alarm_description = "This metric monitor EC2 instance cpu utilization" alarm_actions = ["${aws_autoscaling_policy.CPU-TEST-ScaleUP.arn}"]

tags = {
  Environment = "${var.env}_cpualarmUP"
  Project     = "${var.project}_cpualarmUP"
  Sub_project = "${var.sub_project}_cpualarmUP"
}
}

resource "aws_autoscaling_policy" "CPU-TEST-ScaleDOWN" {
  name = "ScaleDOWN"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  autoscaling_group_name = "${aws_autoscaling_group.project.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarmDOWN" {
  alarm_name = "TEST-CPU(DOWN)"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "40"
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.project.name}"
  }
  alarm_description = "This metric monitor EC2 instance cpu utilization"
  alarm_actions = ["${aws_autoscaling_policy.CPU-TEST-ScaleDOWN.arn}"]

  tags = {
    Environment = "${var.env}_cpualarmDOWN"
    Project     = "${var.project}_cpualarmDOWN"
    Sub_project = "${var.sub_project}_cpualarmDOWN"
}
*/

resource "aws_autoscaling_attachment" "project" {
  autoscaling_group_name = aws_autoscaling_group.project.id
  alb_target_group_arn   = aws_lb_target_group.project.arn
}

resource "aws_launch_configuration" "project" {
  name                 = "web_lc_${var.locals.env_project}"
  image_id             = data.aws_ami.latest_ami_for_ECS.id
  instance_type        = "${var.type_instance}"
  security_groups      = ["${var.sg_id}"]
  iam_instance_profile = "${var.iam_name}"
  key_name             = "${var.key}"
  #health_check_type    = "ELB"
  user_data = templatefile("./user_data/user_data.sh.tpl", {
    aws_ecs_cluster = "${var.cluster_name}",
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "project" {
  name               = "lb_${var.locals.env_project}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.sg_id}"]
  subnets            = "${var.public_subnet_ids}"

    tags = {
      Environment = "${var.env}_alb"
      Project     = "${var.project}_alb"
      Sub_project = "${var.sub_project}_alb"
    }
  }
}

resource "aws_lb_target_group" "project" {
  name     = "lb-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_listener" "project" {
  load_balancer_arn = aws_lb.project.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.project.arn
    type             = "forward"
  }
}
