# Recurso que genera un nombre aleatorio
resource "random_pet" "${name}" {
  length = 2
  separator = "-"
}

# Recurso general nulo
resource "null_resource" "${name}" {
  triggers = {
    env = "${env}"
    pet_name = random_pet.${name}.id
  }

  provisioner "local-exec" {
    command = "echo 'Creando un clon con nombre ${name}'"
  }
}

output "${name}_info"{
    value = {
        env = "${env}"
        pet_name = random_pet.${name}.id
    }
}