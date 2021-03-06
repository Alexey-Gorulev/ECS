resource "aws_ecs_cluster" "project" {
  name = "commentator-development"

  tags = {
    Environment = "${var.env}"
    Project     = "${var.project}"
    Sub_project = "${var.sub_project}"
  }
}

resource "aws_ecs_service" "project" {
  name            = "ecs-service"
  cluster         = "${aws_ecs_cluster.project.id}"
  task_definition = "${aws_ecs_task_definition.project.arn}"
  desired_count   = "${var.count_container}"
  /*
  deployment_controller {
    type = "CODE_DEPLOY"
  }
*/
  load_balancer {
    target_group_arn = "${var.lb_arn}"
    container_name   = "${var.name_container}"
    container_port   = "${var.port_container}"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.public_subnet_names}]"
  }
  depends_on = [
    var.lb,
  ]
  /*
  tags = {
    Environment = "${var.env}"
    Project     = "${var.project}"
    Sub_project = "${var.sub_project}"
  }
*/
}

resource "aws_ecs_task_definition" "project" {
  family                = "task"
  container_definitions = file("./task-definitions/service.json")

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.public_subnet_names}]"
  }

  tags = {
    Environment = "${var.env}"
    Project     = "${var.project}"
    Sub_project = "${var.sub_project}"
  }
}
