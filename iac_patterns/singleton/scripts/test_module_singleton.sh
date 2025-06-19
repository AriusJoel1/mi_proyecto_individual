#!/bin/bash

set -e

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCK_FILE="$MODULE_DIR/instance.lock"

echo "Limpiando archivos"
rm -f "$LOCK_FILE"

echo "Inicializando modulo Singleton..."
cd "$MODULE_DIR"
terraform init -input=false
terraform apply -auto-approve

echo "Validando creación del LOCK_FILE..."
if [ -f "$LOCK_FILE" ]; then
  echo "LOCK_FILE creado correctamente."
else
  echo "Archivo no encontrado."
  exit 1
fi

echo "Obteniendo outputs..."
CREATE_INSTANCE_OUTPUT=$(terraform output -raw create_instance)
SINGLETON_STATUS_OUTPUT=$(terraform output -json singleton_status)

if [[ "$CREATE_INSTANCE_OUTPUT" == *"habilitada."* ]]; then
  echo "[OK] Output de creación correcto."
else
  echo "[ERROR] Output de creación inesperado."
  exit 1
fi

echo "Destruyendo infraestructura..."
terraform destroy -auto-approve

echo "Validando limpieza del LOCK_FILE..."
if [ ! -f "$LOCK_FILE" ]; then
  echo "[ERROR] LOCK_FILE eliminado correctamente."
else
  echo "[OK] LOCK_FILE aún existe tras destruir la infraestructura."
  exit 1
fi

