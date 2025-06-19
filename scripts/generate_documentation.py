import os
import re


def generate_documentation():
    """
    Generador de documentación para los patrones de diseño en IaC.
    Incluye descripción breve desde README.md y un ejemplo de ejecución.
    (Builder, Composite, Factory, Prototype, Singleton)
    """

    # verifica si la carpeta docs existe
    if not os.path.exists("../docs"):
        os.makedirs("docs")

    # dirección donde buscara archivos
    path = "../iac_patterns"

    # enlista todos los nombres de los archivos dentro de path
    dir_list = os.listdir(path)

    for file in dir_list:
        # ruta para buscar los patrones
        patterns_path = os.path.join(path, file)
        # ruta para encontrar variables.tf y README.md en cada patrón
        vars_path = os.path.join(patterns_path, "variables.tf")
        output_tf_path = os.path.join(patterns_path, "outputs.tf")
        readme_path = os.path.join(patterns_path, "README.md")

        # Extrae variables
        if os.path.exists(vars_path):
            with open(vars_path, "r") as vars:
                content = vars.read()

                variables = re.findall(r'(variable\s+"[\w_]+"\s*{[^}]*})', content)
                # Patron de busqueda:
                # variable "<nombre>" {
                # <cualquier-texto>
                # }

        # Extrae outputs
        if os.path.exists(output_tf_path):
            with open(output_tf_path, "r") as output_tf:
                content = output_tf.read()

                outputs = re.findall(r'(output\s+"[\w_]+"\s*{[^}]*})', content)
                # Patron de busqueda:
                # output "<nombre>" {
                # <cualquier-texto>
                # }

        # Extrae descripciones
        if os.path.exists(readme_path):
            with open(readme_path, "r") as readme:
                descriptions = readme.read().strip()

        with open(f"../docs/{file}.md", "w") as doc:
            # doc.write(f"# Patron {file.capitalize()}\n\n")
            doc.write(f"{descriptions}\n\n")
            doc.write("### Variables\n\n")

            for variable in variables:
                doc.write("```json\n")
                doc.write(f"{variable}\n")
                doc.write("```\n\n")

            doc.write("### Outputs\n\n")
            for output in outputs:
                doc.write("```json\n")
                doc.write(f"{output}\n")
                doc.write("```\n\n")

            doc.write("## Ejemplo de invocacion\n\n")
            # Diccionario con las instrucciones específicas para cada patrón
            instructions = {
                "singleton": [
                    "```bash\n",
                    "cd ./iac_patterns/singleton\n",
                    "terraform init\n",
                    "terraform apply -auto-approve\n",
                    "```\n\n",
                    "- **Verificacion de instancia creada**\n\n",
                    "```bash\n",
                    "# en ./iac_patterns/singleton\n",
                    "cd scripts\n",
                    "chmod +x singleton.sh\n",
                    "./singleton.sh\n",
                    "```\n"
                ],
                "prototype": [
                    "- **Generas el prototipo a base de la plantilla ubicada en `templates`**\n\n",
                    "```bash\n",
                    "cd ./iac_patterns/prototype\n",
                    "terraform init\n",
                    "terraform apply -auto-approve\n",
                    "```\n\n",
                    "- **A base de esta plantilla se generan clones.**\n\n",
                    "```bash\n",
                    "# en ./iac_patterns/prototype\n",
                    "cd scripts\n",
                    "# crea 1 clon\n",
                    "python clone_prototype.py\n",
                    "```\n"
                ],
                "factory": [
                    "```bash\n",
                    "cd ./iac_patterns/factory\n",
                    "terraform init\n",
                    "terraform apply -auto-approve\n",
                    "```\n"
                ],
                "composite": [
                    "```bash\n",
                    "cd ./iac_patterns/composite\n",
                    "terraform init\n",
                    "terraform apply -auto-approve\n",
                    "```\n"
                ],
                "builder": [
                    "```bash\n",
                    "cd ./iac_patterns/builder\n",
                    "terraform init\n",
                    "terraform apply -auto-approve\n",
                    "```\n"
                ]
            }
        doc.writelines(instructions.get(file, ["* Work in progress...*\n"]))


if __name__ == "__main__":
    generate_documentation()
