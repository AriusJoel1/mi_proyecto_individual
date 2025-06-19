import sys
import os
import time
import copy
import random


class TerraformPrototype:
    """
    Clase que representa un prototipo de archivo Terraform.
    Permite clonar el archivo y reemplazar variables en su contenido.
    """
    def __init__(self, filepath, replacements):
        """
        Inicializa el prototipo con la ruta del archivo y las variables a reemplazar.
        """
        self.filepath = filepath
        self.replacements = replacements
        self.content = self._read_file()

    def _read_file(self):
        """
        Lee el contenido del archivo original y lo retorna como string.
        """
        with open(self.filepath, "r") as file:
            return file.read()

    def clone(self):
        """
        Clona el prototipo usando copy.deepcopy y reemplaza las variables en el contenido.
        """
        # Se hace una copia del objeto actual
        prototype_copy = copy.deepcopy(self)
        # Por cada variable a reemplazar, se hace el cambio en el contenido
        # diccionario
        for key, value in prototype_copy.replacements.items():
            prototype_copy.content = prototype_copy.content.replace(key, value)
        return prototype_copy

    def save(self, output_path):
        """
        Guarda el contenido modificado en un nuevo archivo.
        """
        with open(output_path, "w") as file:
            file.write(self.content)


def create_clone(count):
    """
    Función principal que gestiona la clonación del archivo Terraform.
    
    args:
        count: cantidad de clones a crear.
    """
    # Directorio actual del script
    script_dir = os.path.dirname(os.path.abspath(__file__))
    # Subir un nivel para obtener la raíz del proyecto ("prototype/")
    base_dir = os.path.abspath(os.path.join(script_dir, ".."))

    # Ruta hacia el prototipo
    prototype_tf = os.path.join(base_dir, "templates", "prototype.hcl.tpl")

    # Verifica que la plantilla exista
    if not os.path.isfile(prototype_tf):
        print(f"Archivo {prototype_tf} no encontrado.")
        sys.exit(1)

    # Genera un timestamp para el archivo clonado
    for clon_count in range(count):
        random_name = random.randint(1000,9999)
        timestamp = time.strftime("%Y%m%d-%H%M%S")
        clon_file = f"clon_{clon_count+1}.tf"
        out_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), clon_file)

        # Diccionario con las variables a reemplazar
        replacements = {
            "${name}" : f"file_{random_name}",
            "${env}" : f"entorno_{timestamp}"
        }

        # Crea el prototipo, lo clona y guarda el resultado
        prototype = TerraformPrototype(prototype_tf, replacements)
        clon = prototype.clone()
        clon.save(out_path)

    print("Archivo clonado y modificado.")


if __name__ == "__main__":
    # creación de N clones a base de una plantilla
    create_clone(3)
