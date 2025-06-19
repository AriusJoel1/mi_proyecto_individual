variable "instance_name" {
  type        = string
  description = "Nombre único de la instancia."
  default     = "test-singleton"
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia a crear."
  default     = "basic"
}

# gestiona ciclo de vida de la instancia
variable "instance_enabled" {
  type        = bool
  default     = true
  description = "Habilita/deshabilita la creación de la instancia."
}