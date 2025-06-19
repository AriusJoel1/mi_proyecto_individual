# src/builder/variables.tf

variable "step1_initialize_env_enabled" {
  type        = bool
  description = "Habilitar paso 1: Inicializar entorno base."
  default     = true
}

variable "step1_config" {
  type        = map(string)
  description = "Configuración para el paso 1."
  default     = {
    name = "BaseEnvironment"
    type = "Development"
  }
}

variable "step2_configure_network_enabled" {
  type        = bool
  description = "Habilitar paso 2: Configurar la red."
  default     = true
}

variable "step2_config" {
  type        = map(string)
  description = "Configuración para el paso 2."
  default     = {
    cidr_block   = "10.0.0.0/16"
    subnet_count = "2"
  }
}

variable "step3_deploy_app_enabled" {
  type        = bool
  description = "Habilitar paso 3: Desplegar la aplicación."
  default     = false
}

variable "step3_config" {
  type        = map(string)
  description = "Configuración para el paso 3."
  default     = {
    app_name    = "MyWebApp"
    app_version = "v1.0.2"
  }
}

# NUEVAS VARIABLES PARA LA INVOCACIÓN DEL FACTORY DESDE EL BUILDER
variable "invoke_factory_enabled" {
  type        = bool
  description = "Controla si el Builder debe invocar al módulo Factory."
  default     = false
}

variable "factory_module_config" {
  description = "Configuración a pasar al módulo Factory cuando es invocado por el Builder."
  type = object({
    factory_type       = string
    file_name          = optional(string) # El módulo factory tiene sus propios defaults
    file_content       = optional(string) # El módulo factory tiene sus propios defaults
    random_byte_length = optional(number) # El módulo factory tiene sus propios defaults
  })
  default = { # Un default razonable para el objeto si no se proporciona toda la estructura
    factory_type = "local_file"
  }
  validation {
    condition     = contains(["local_file", "random_id"], var.factory_module_config.factory_type)
    error_message = "El valor de factory_type en factory_module_config debe ser 'local_file' o 'random_id'."
  }
}