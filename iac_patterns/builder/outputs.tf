# src/builder/outputs.tf

output "builder_summary" {
  description = "Resumen del proceso de construcción y los pasos ejecutados."
  value = {
    step1_initialize_env = var.step1_initialize_env_enabled ? {
      status  = "Ejecutado"
      details = length(null_resource.step1_initialize_env) > 0 ? null_resource.step1_initialize_env[0].triggers : null
    } : {
      status  = "Omitido"
      details = null
    }
    step2_configure_network = var.step2_configure_network_enabled ? {
      status  = "Ejecutado"
      details = length(null_resource.step2_configure_network) > 0 ? null_resource.step2_configure_network[0].triggers : null
    } : {
      status  = "Omitido"
      details = null
    }
    step3_deploy_app = var.step3_deploy_app_enabled ? {
      status  = "Ejecutado"
      details = length(null_resource.step3_deploy_app) > 0 ? null_resource.step3_deploy_app[0].triggers : null
    } : {
      status  = "Omitido"
      details = null
    }
    # NUEVO: Output para el recurso creado por el Factory invocado por el Builder
    product_from_invoked_factory = var.invoke_factory_enabled ? {
      status  = "Ejecutado"
      # Accedemos al output 'product_details' del módulo factory
      details = length(module.product_created_by_factory) > 0 ? module.product_created_by_factory[0].product_details : null
    } : {
      status  = "Omitido"
      details = null
    }
  }
}

output "final_message" {
  description = "Un mensaje indicando el estado general."
  value = join(" -> ", compact(concat(
    var.step1_initialize_env_enabled ? ["Entorno Inicializado"] : [],
    var.step2_configure_network_enabled ? ["Red Configurada"] : [],
    var.step3_deploy_app_enabled ? ["App Desplegada"] : [],
    # NUEVO: Mensaje para el factory invocado
    var.invoke_factory_enabled && length(module.product_created_by_factory) > 0 ?
    ["Recurso Factory '${module.product_created_by_factory[0].product_details.type_created}' Creado por Builder"] :
    (var.invoke_factory_enabled ? ["Intento de crear Recurso Factory (fallido o sin detalles)"] : [])
  )))
}