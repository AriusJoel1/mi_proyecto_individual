variable "parent_name" {
  type        = string
  description = "Nombre del módulo padre"
  default     = "Módulo padre"
}

variable "enable_subtask" {
  type        = bool
  description = "Habilitar o deshabilitar subtarea"
  default     = true
}

variable "task_priority" {
  type        = number
  description = "Prioridad de la subtarea"
  default     = 1
}

variable "task_description" {
  type        = string
  description = "Descripción de la subtarea"
  default     = "Sin descripción"
}
