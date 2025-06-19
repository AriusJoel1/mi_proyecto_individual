output "create_instance" {
  # 1: true , 0: false
  value       = var.instance_enabled ? "${var.instance_name} habilitada." : "${var.instance_name} deshabilitada."
  description = "Estado de la instancia."
}

output "singleton_status" {
  value = {
    enabled = var.instance_enabled
    name    = var.instance_name
    type    = var.instance_type
  }
  description = "Estado actual del modulo singleton."
}