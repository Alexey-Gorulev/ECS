locals {
  env_project = "${var.environment}_${var.project}"
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs_instance_role_${var.locals.env_project}"

  assume_role_policy = file("./policy_data/policy_data.json")

  tags = {
    Environment = "${var.env}_iam_role"
    Project     = "${var.project}_iam_role"
    Sub_project = "${var.sub_project}_iam_role"
  }
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs_instance_profile_${var.env}"
  role = "${aws_iam_role.ecs_instance_role.name}"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = "${aws_iam_role.ecs_instance_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
