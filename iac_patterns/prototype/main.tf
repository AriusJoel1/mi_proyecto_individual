# providers para la creación de local_files y templates
terraform {
  required_version = ">= 0.13"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }

    template = {
      source  = "hashicorp/template"
      version = "~> 2.1"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}
resource "local_file" "prototype_generator" {
  content  = data.template_file.prototype_template.rendered
  filename = "${path.module}/example.tf"
}

data "template_file" "prototype_template" {
  template = file("${path.module}/templates/prototype.hcl.tpl")
  vars = {
    name = var.name
    env  = var.env
  }
}