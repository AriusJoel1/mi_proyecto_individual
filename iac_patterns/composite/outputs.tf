output "generate_structure" {
  value       = "Padre: ${var.name} con ${module.subtask1.subtask_count + module.subtask2.subtask_count} hijos."
  description = "Cantidad de hijos generada en base del recurso padre."
}