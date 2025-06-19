#!/bin/bash

set -e

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$MODULE_DIR"

echo "Inicializando infraestructura..."
terraform init -input=false
terraform apply -auto-approve

echo "Validando archivos generados..."
if [ -f "${MODULE_DIR}/example.tf" ]; then
  echo "Archivo example.tf generado correctamente."
else
  echo "ERROR: example.tf no fue generado."
  exit 1
fi

echo "Validando outputs..."
OUTPUT=$(terraform output -json create_prototype 2>/dev/null)
if [[ "$OUTPUT" == *"generado con exito"* ]]; then
  echo "Output create_prototype válido: $OUTPUT"
else
  echo "ERROR: Output create_prototype no es válido."
  exit 1
fi

echo "Destruyendo recursos Terraform..."
terraform destroy -auto-approve > /dev/null 2>&1