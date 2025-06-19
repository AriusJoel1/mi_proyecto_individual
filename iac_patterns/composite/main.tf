resource "null_resource" "crucial_task" {
  triggers = {
    name = var.name
  }

  provisioner "local-exec" {
    command = "echo Ejecutando tarea principal: ${var.name}"
  }
}

module "subtask1" {
  source           = "./modules/subtask1"
  enable_subtask   = var.enable_subtask1
  parent_name      = var.name
  task_priority    = 5
  task_description = "Subtarea 1 crítica"
}

module "subtask2" {
  source           = "./modules/subtask2"
  enable_subtask   = var.enable_subtask2
  parent_name      = var.name
  task_priority    = 3
  task_description = "Subtarea 2 secundaria"
}
