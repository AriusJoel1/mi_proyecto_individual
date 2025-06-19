#!/bin/bash

set -eou # este script termina por error de comando o de parte de tubería, o por variable indefinida

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$MODULE_DIR"

# Probando el ciclo de vida del módulo

echo "Inicializando infraestructura..."
terraform init -input=false

echo "Aplicando infraestructura..."
terraform apply -auto-approve

echo "Validando outputs..."
OUTPUT=$(terraform output -json generate_structure 2>/dev/null)

if [[ "$OUTPUT" == *"hijos"* ]]; then
  echo "Output generate_structure válido: $OUTPUT"
else
  echo "ERROR: Output generate_structure no es válido."
  exit 1
fi

echo "Destruyendo recursos Terraform..."
terraform destroy -auto-approve > /dev/null 2>&1

echo "Prueba del patrón Composite finalizada correctamente."
