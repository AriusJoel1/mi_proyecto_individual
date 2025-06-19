output "task_name" {
  value = local.name
}

# Exportar cuántas instancias se crearon
output "subtask_count" {
  value = length(null_resource.subtask2)
}

output "task_priority" {
  value = var.task_priority
}

output "task_description" {
  value = var.task_description
}
