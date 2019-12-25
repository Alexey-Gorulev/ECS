resource "aws_ecs_cluster" "test" {
  name = "ecs-cluster"
}

resource "aws_ecs_service" "test" {
  name            = "ecs-service"
  cluster         = aws_ecs_cluster.test.id
  task_definition = aws_ecs_task_definition.test.arn
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
}

resource "aws_ecs_task_definition" "test" {
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
}
