// src/builder/builder_inputs.tfvars // (o iac_patterns/builder/builder_inputs.tfvars)

step1_initialize_env_enabled = true
step1_config = {
  name = "ProductionBase"
  type = "HighAvailability"
}

step2_configure_network_enabled = true
step2_config = {
  cidr_block   = "10.100.0.0/16"
  subnet_count = "3"
}

step3_deploy_app_enabled = true
step3_config = {
  app_name    = "CriticalServiceApp"
  app_version = "v2.1.0"
}

invoke_factory_enabled = true
factory_module_config = {
  factory_type = "local_file"
  file_name    = "txt_usando_factory_dentro_de_builder.txt"
  file_content = "Este archivo fue generado por el Factory, invocado desde un paso del Builder."
}