resource "aws_ecs_cluster" "project" {
  name = "ecs-cluster"

  tags = {
    Environment = "${var.env}_ecs_cluster"
    Project     = "${var.project}_ecs_cluster"
    Sub_project = "${var.sub_project}_ecs_cluster"
  }
}

resource "aws_ecs_service" "project" {
  name            = "ecs-service"
  cluster         = aws_ecs_cluster.project.id
  task_definition = aws_ecs_task_definition.project.arn
  desired_count   = "${var.count_container}"

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

  tags = {
    Environment = "${var.env}_ecs_service"
    Project     = "${var.project}_ecs_service"
    Sub_project = "${var.sub_project}_ecs_service"
  }
}

resource "aws_ecs_task_definition" "project" {
  family                = "service"
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
    Environment = "${var.env}_ecs_task_definition"
    Project     = "${var.project}_ecs_task_definition"
    Sub_project = "${var.sub_project}_ecs_task_definition"
  }
}
