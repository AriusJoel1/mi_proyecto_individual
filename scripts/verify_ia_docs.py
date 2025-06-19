import os
import re

DOCS_DIR = "../docs"
GENERIC_PHRASES = [
    "El patrón", "Su propósito es", "Esto permite", "Su implementación se basa en",
    "Es especialmente útil", "permite crear", "garantiza que", "encapsula la creación",
    "de objetos", "de la misma forma", "de forma", "de objetos complejos",
    "de la lógica", "de recursos", "de instancias", "de componentes", "de clases",
    "de parámetros", "de configuración", "de dependencias", "de inicialización",
    "de construcción", "de generación", "de variantes", "de estructura", "de árbol",
    "de composición", "de clonación", "de copia", "de referencia", "de acceso global",
    "de desacoplar", "de centralizar", "de encapsular", "de evitar duplicados",
    "de facilitar", "de mejorar", "de separar", "de orquestar", "de retener el estado",
    "de producir", "de construir", "de aplicar", "de propagar", "de distinguir",
    "de delegar", "de operar", "de replicar", "de repetir", "de exponer", "de copiar",
    "de almacenar", "de formar", "de componer", "de componer estructuras"
]


def is_generic_phrase(linea):
    """
    Analiza las frases genéricas de la lista de frases (se puede ampliar la lógica)
    """
    if len(linea.strip()) > 120:
        return True
    for frase in GENERIC_PHRASES:
        if frase in linea:
            return True
    if re.match(r"^El patrón [A-Z][a-z]+", linea):
        return True
    return False


def analyze_markdown(filepath):
    """
    revisa todos los archivos de la forma docs/<patrón>.md,
    si hay similitud con las frases genéricas agrega una sospecha
    """
    total = 0
    sospechosas = 0
    with open(filepath,) as file:
        for linea in file:
            if linea.strip() == "" or linea.strip().startswith("#"):
                continue
            total += 1
            if is_generic_phrase(linea):
                sospechosas += 1
    porcentaje = (sospechosas / total * 100) if total > 0 else 0
    return porcentaje


def classify(porcentaje):
    """
    Clasificación simple de porcentaje de uso de IAs o texto copiado de internet.
    """
    if porcentaje < 10:
        return "Escrito por un humano."
    elif porcentaje <= 30:
        return "intervención leve de IA."
    else:
        return "texto generado por IA."


def main():
    for archivo in os.listdir(DOCS_DIR):
        if archivo.endswith(".md"):
            ruta = os.path.join(DOCS_DIR, archivo)
            porcentaje = analyze_markdown(ruta)
            print(f"{archivo}: {classify(porcentaje)}")


if __name__ == "__main__":
    main()
