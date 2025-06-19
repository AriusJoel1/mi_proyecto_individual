import pytest
from scripts.verify_state import parse_resources

@pytest.fixture
def sample_content():
    # Simula un recurso de ejemplo con una instancia
    return {
        "resources": [
            {
                "type": "null_resource",
                "name": "example",
                "instances": [
                    {
                        "attributes": {
                            "id": "chicken-jockey",
                            "triggers": {}
                        }
                    }
                ]
            }
        ]
    }

def test_parse_resources(sample_content):
    result = parse_resources(sample_content)
    assert isinstance(result, list)
    assert result[0]["type"] == "null_resource"
    assert result[0]["name"] == "example"
    assert result[0]["instances"][0]["id"] == "chicken-jockey"