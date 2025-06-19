# provider de recursos nulos
terraform {
  required_version = ">= 0.13"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}
# instancia
resource "null_resource" "instance" {
  count = var.instance_enabled ? 1 : 0

  triggers = {
    instance_name = var.instance_name
    instance_type = var.instance_type
    tag           = timestamp()
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    # script que no permite la creación de multiples instancias
    command = "./scripts/singleton.sh"
  }

}