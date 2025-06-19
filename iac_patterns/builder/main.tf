# src/builder/main.tf

# Paso 1: Inicializar el entorno
resource "null_resource" "step1_initialize_env" {
  count = var.step1_initialize_env_enabled ? 1 : 0
  triggers = {
    action    = "Initialize Environment"
    name      = var.step1_config.name
    type      = var.step1_config.type
    timestamp = timestamp()
  }
}

# Paso 2: Configurar la red
resource "null_resource" "step2_configure_network" {
  count = var.step2_configure_network_enabled ? 1 : 0
  triggers = {
    action       = "Configure Network"
    cidr_block   = var.step2_config.cidr_block
    subnet_count = var.step2_config.subnet_count
    timestamp    = timestamp()
  }
  depends_on = [null_resource.step1_initialize_env]
}

# Paso 3: Desplegar la aplicación
resource "null_resource" "step3_deploy_app" {
  count = var.step3_deploy_app_enabled ? 1 : 0
  triggers = {
    action      = "Deploy Application"
    app_name    = var.step3_config.app_name
    app_version = var.step3_config.app_version
    timestamp   = timestamp()
  }
  depends_on = [null_resource.step2_configure_network]
}

module "product_created_by_factory" {
  count = var.invoke_factory_enabled ? 1 : 0 # Solo se crea si está habilitado

  source = "../factory" # Ruta relativa al módulo factory

  factory_type = var.factory_module_config.factory_type

  file_name          = try(var.factory_module_config.file_name, null)
  file_content       = try(var.factory_module_config.file_content, null)
  random_byte_length = try(var.factory_module_config.random_byte_length, null)

  depends_on = [
    null_resource.step3_deploy_app
  ]
}