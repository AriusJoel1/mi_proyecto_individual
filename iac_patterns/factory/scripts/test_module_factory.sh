#!/bin/bash

set -eou pipefail  # Terminar en caso de error de comando, variable indefinida o fallo en tubería

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$MODULE_DIR"

echo "Probando ciclo de vida del módulo Factory..."

echo "Inicializando Terraform..."
terraform init -input=false > /dev/null

echo "Aplicando infraestructura con factory_type='local_file'..."
terraform apply -auto-approve -var="factory_type=local_file" \
                               -var="file_name=test_output.txt" \
                               -var="file_content=Contenido de prueba" \
                               -var="file_path_prefix=./factory_module" > /dev/null

EXPECTED_FILE="./factory_module/test_output.txt"
echo "Verificando existencia de archivo: $EXPECTED_FILE"
if [[ -f "$EXPECTED_FILE" ]]; then
  echo "Archivo encontrado: $EXPECTED_FILE"
else
  echo "ERROR: Archivo no fue creado."
  terraform destroy -auto-approve > /dev/null 2>&1
  exit 1
fi

echo "Verificndo contenido del archivo..."
CONTENT=$(cat "$EXPECTED_FILE")
if [[ "$CONTENT" == "Contenido de prueba" ]]; then
  echo "El contenido del archivo es correcto."
else
  echo "ERROR: Contenido del archivo es incorrecto: $CONTENT"
  terraform destroy -auto-approve > /dev/null 2>&1
  exit 1
fi

echo "Validando output product_summary..."
SUMMARY=$(terraform output -json product_summary 2>/dev/null | jq -r .)
if [[ "$SUMMARY" == *"$EXPECTED_FILE"* ]]; then
  echo "Output product_summary válido: $SUMMARY"
else
  echo "ERROR: Output product_summary no contiene ruta esperada."
  terraform destroy -auto-approve > /dev/null 2>&1
  exit 1
fi

echo "Destruyendo recursos Terraform..."
terraform destroy -auto-approve > /dev/null 2>&1

echo "Eliminando archivo residual (por si Terraform no lo borra)"
[[ -f "$EXPECTED_FILE" ]] && rm -f "$EXPECTED_FILE"

echo "Prueba del patrón Factory finalizada exitosamente."