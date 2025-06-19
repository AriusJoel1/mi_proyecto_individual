#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR" || exit

# Configuración inicial
FACTORY_TYPE=${1:-local_file}
CONFIG_FILE="factory_config.json"

# Validar tipo de fábrica
if [[ "$FACTORY_TYPE" != "local_file" && "$FACTORY_TYPE" != "random_id" ]]; then
  echo "Error: tipo de fábrica no válido. Usa 'local_file' o 'random_id'."
  exit 1
fi

echo "Iniciando fábrica: tipo '$FACTORY_TYPE'"

# Generar archivo de configuración
echo "Generando archivo '$CONFIG_FILE'..."
cat <<EOF > $CONFIG_FILE
{
  "factory_type": "${FACTORY_TYPE}",
  "file_name": "producto_${FACTORY_TYPE}.txt",
  "file_content": "Archivo generado por la fábrica.",
  "random_byte_length": 8
}
EOF

echo "Ejecutando Terraform..."
terraform init -upgrade > /dev/null
terraform apply -auto-approve -var-file="./${CONFIG_FILE}"

# Limpieza
echo "Eliminando archivo de configuración..."
rm $CONFIG_FILE

echo "Proceso completado."
