import pytest
import tempfile
import os
from scripts.verify_ia_docs import analyze_markdown, classify


# documento.md de ejemplo con ciertas lineas de código genéricas
@pytest.fixture
def sample_markdown_file():
    content = (
        "# Título\n"
        "El patrón Singleton es ampliamente utilizado.\n"
        "Esto es una línea normal escrita por un humano.\n"
        "Su propósito es garantizar que una clase tenga una única instancia.\n"
        "\n"
        "Otra línea normal.\n"
    )
    with tempfile.NamedTemporaryFile("w+", delete=False, suffix=".md") as doc:
        doc.write(content)
        doc_path = doc.name
    yield doc_path
    os.remove(doc_path)


def test_analyze_markdown(sample_markdown_file):
    porcentaje = analyze_markdown(sample_markdown_file)
    assert porcentaje == 50.0


@pytest.mark.parametrize(
    "porcentaje,expected",
    [
        (0, "Escrito por un humano."),
        (9.9, "Escrito por un humano."),
        (10, "intervención leve de IA."),
        (25, "intervención leve de IA."),
        (30, "intervención leve de IA."),
        (31, "texto generado por IA."),
        (100, "texto generado por IA."),
    ]
)
def test_classify(porcentaje, expected):
    assert classify(porcentaje) == expected
