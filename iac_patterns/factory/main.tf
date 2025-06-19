terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.2.3" 
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3" 
    }
  }
}

# Producto A: crea un archivo local
# Solo se aplica si el tipo de fábrica es "local_file"
resource "local_file" "product_file" {
  count    = var.factory_type == "local_file" ? 1 : 0

  content  = var.file_content
  filename = "${var.file_path_prefix}/${var.file_name}"
}

# Producto B: genera un ID aleatorio
# Solo se aplica si el tipo de fábrica es "random_id"
resource "random_id" "product_id" {
  count = var.factory_type == "random_id" ? 1 : 0

  byte_length = var.random_byte_length
}
