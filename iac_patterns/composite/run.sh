#!/bin/bash

# Cambiar a la ruta del script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR" || exit

# Entradas: nombre de la tarea y activación de subtareas
TASK_NAME=${1:-TareaPrincipal}
ENABLE_SUBTASK1=${2:-true}
ENABLE_SUBTASK2=${3:-false}

CONFIG_FILE="main_config.json"

echo "Configurando:"
echo "  Nombre de tarea    : $TASK_NAME"
echo "  Subtarea 1 activada: $ENABLE_SUBTASK1"
echo "  Subtarea 2 activada: $ENABLE_SUBTASK2"

# Generar archivo de configuración
cat <<EOF > $CONFIG_FILE
{
  "name": "$TASK_NAME",
  "enable_subtask1": $ENABLE_SUBTASK1,
  "enable_subtask2": $ENABLE_SUBTASK2
}
EOF

# Ejecutar Terraform
terraform init -upgrade > /dev/null
terraform apply -auto-approve -var-file="$CONFIG_FILE"

# Limpiar archivo
rm "$CONFIG_FILE"
echo "Ejecución completada."
