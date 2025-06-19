import json
import os
from pathlib import Path
from typing import List, Dict


def parse_resources(content: Dict):
    """
    Parsea los argumentos más importantes para armar un diccionario resumido de los recursos
    Argumentos:
      content: diccionario que representa un estado de infraestructura de terraform
    """
    file_resources: List[Dict[str, str]] = []
    for resource in content["resources"]:
        type = resource["type"]
        name = resource["name"]
        instances: List[Dict[str, str]] = []
        for instance in resource["instances"]:
            id = instance["attributes"]["id"]
            # algunas instancias no tienen padre
            if "parent" in instance["attributes"]["triggers"]:
                parent = instance["attributes"]["triggers"]["parent"]
                instances.append({
                        "id": id,
                        "parent": parent
                    })
            else:
                instances.append({"id": id})
        file_resources.append({
                "type": type,
                "name": name,
                "instances": instances
            })
    return file_resources


# Busca y lee todos los archivos de estado terraform.tfstate en src/
path = "../iac_patterns"
dir_list = os.listdir(path)
whole_state = {"whole_state": []}
for directory in dir_list:
    file_path = os.path.join(path, directory, "terraform.tfstate")
    if not Path(file_path).is_file():
        continue  # omite archivos que no existen
    with open(file_path, "r") as f:
        content = json.loads(f.read())
        # Resume el estado
        file_resources = parse_resources(content)
        whole_state["whole_state"].append({
            "source": str(file_path),
            "resources": file_resources
        })

# Almacena los resumenes en un solo archivo verify_state.json
with open("verify_state.json", "w") as f:
    f.write(json.dumps(whole_state, indent=2))
