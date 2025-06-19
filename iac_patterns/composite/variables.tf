variable "name" {
  type        = string
  description = "Nombre del recurso padre"
  default     = "RecursoPadre"
}

variable "enable_subtask1" {
  type    = bool
  default = true
}

variable "enable_subtask2" {
  type    = bool
  default = true
}