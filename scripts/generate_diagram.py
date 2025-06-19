#!/usr/bin/env python3
import argparse
import os


def generate_diagram(pattern: str, output: str):
    """
    Genera un diagrama de la infraestructura hecha con Terraform.
    Ejecuta el comando 'terraform graph' en el directorio correspondiente al patrón
    y convierte la salida DOT en una imagen usando la herramienta 'dot' (de Graphviz).

    Args:
        pattern (str): Nombre del patrón de diseño (ej. 'composite', 'singleton').
        output (str): Nombre del archivo de salida, con extensión (ej. 'output.png').
    """
    # separa nombre base y extensión
    name, _, ext = output.rpartition(".")
    # ejecuta terraform graph y lo pasa por dot para generar la imagen
    os.system(f"terraform -chdir=../iac_patterns/{pattern} graph | dot -T{ext} -o ../docs/{output}")
    print("Patrón: ", pattern)
    print("Archivo de salida: ", output)


def parse_args():
    """
    Parsea los argumentos de línea de comandos proporcionados por el usuario.
    Retorna objeto con los argumentos pareados.
    """
    parser = argparse.ArgumentParser(
        description="Genera un diagrama visual a partir de infraestructura local de Terraform."
    )
    parser.add_argument(
        "-p", "--pattern",
        required=True,
        choices=["singleton", "composite", "factory", "prototype", "builder"],
        help="Nombre del patrón de diseño cuyo módulo Terraform se va a graficar."
    )
    args = parser.parse_args()
    parser.add_argument(
        "-o", "--output",
        default=f"{args.pattern}.png",
        help="Nombre del archivo de salida (ej. diagrama.png). \
            Por defecto usa el nombre del patrón con extensión .png."
    )
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    generate_diagram(args.pattern, args.output)
