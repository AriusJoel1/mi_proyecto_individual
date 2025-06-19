locals {
  name = "${var.parent_name}_subtask1"
}

resource "null_resource" "subtask1" {
  count = var.enable_subtask ? 1 : 0

  triggers = {
    name = local.name
  }

  provisioner "local-exec" {
    command = "echo Ejecutando tarea para ${local.name} con prioridad ${var.task_priority} - ${var.task_description}"
  }
}