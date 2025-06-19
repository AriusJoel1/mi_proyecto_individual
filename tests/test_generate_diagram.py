from unittest.mock import patch
from scripts.generate_diagram import generate_diagram

def test_generate_diagram(capsys):
    """
    Prueba que generate_diagram invoque os.system con el comando correcto
    y que imprima el patrón y el archivo de salida.
    """
    pattern = "singleton"
    output = "singleton.png"
    expected_cmd = (
        "terraform -chdir=../iac_patterns/singleton graph | dot -Tpng -o ../docs/singleton.png"
    )

    with patch("os.system") as mock:
        generate_diagram(pattern, output)
        mock.assert_called_once_with(expected_cmd)
        diagram_result = capsys.readouterr()
        assert "Patrón: " in diagram_result.out
        assert pattern in diagram_result.out
        assert "Archivo de salida: " in diagram_result.out
        assert output in diagram_result.out