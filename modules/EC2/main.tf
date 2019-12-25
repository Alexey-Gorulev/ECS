data "aws_ami" "latest_ami_for_ECS" {
  owners      = ["591542846629"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"]
  }
}

resource "aws_autoscaling_group" "test" {
  name                 = "asg"
  max_size             = "${var.asg_max_size}"
  min_size             = "${var.asg_min_size}"
  desired_capacity     = "${var.asg_desired_capacity}"
  vpc_zone_identifier  = "${var.public_subnet_ids}"
  launch_configuration = aws_launch_configuration.test.name
  health_check_type    = "ELB"

  tag {
    key                 = "Name"
    value               = "ASG-Server"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "test" {
  autoscaling_group_name = aws_autoscaling_group.test.id
  alb_target_group_arn   = aws_lb_target_group.test.arn
}

resource "aws_launch_configuration" "test" {
  name                 = "web_lc"
  image_id             = data.aws_ami.latest_ami_for_ECS.id
  instance_type        = "${var.type_instance}"
  security_groups      = ["${var.sg_id}"]
  iam_instance_profile = "${var.iam_name}"
  key_name             = "${var.key}"
  user_data = templatefile("./user_data/user_data.sh.tpl", {
    aws_ecs_cluster = "${var.cluster_name}",
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "test" {
  name               = "lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.sg_id}"]
  subnets            = "${var.public_subnet_ids}"

  tags = {
    Name = "test-alb"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "lb-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.test.arn
    type             = "forward"
  }
}
