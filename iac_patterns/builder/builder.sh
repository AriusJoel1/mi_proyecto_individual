#!/usr/bin/env bash
set -euo pipefail

CFG="build_config.yaml"
[[ -f $CFG ]] || { echo "[ERROR] No se encontró $CFG"; exit 1; }

# --- Lectura de settings globales ---
TERRAFORM_CMD=$(grep -m1 'terraform_command:' "$CFG" \
  | cut -d: -f2- | tr -d ' "')
AUTO_APPROVE_FLAG=$([[ $(grep -m1 'auto_approve:' "$CFG" \
  | grep -Eo 'true|false') == true ]] && echo "-auto-approve" || echo "")

echo "[INFO] Terraform: $TERRAFORM_CMD $AUTO_APPROVE_FLAG"

# --- Extraer primer bloque de build_steps ---
# Captura desde la línea con "- name:" hasta la siguiente línea en blanco
FIRST_BLOCK=$(awk '/build_steps:/{p=1;next} p' "$CFG" \
  | sed -n '/^- name:/,/^$/p')

# --- Obtener propiedades del bloque ---
step_name=$(echo "$FIRST_BLOCK" \
  | grep -m1 'name:' \
  | sed 's/.*name:[[:space:]]*//;s/[",]//g')
step_dir=$(echo "$FIRST_BLOCK" \
  | grep -m1 'directory:' \
  | sed 's/.*directory:[[:space:]]*//;s/[",]//g')
step_action=$(echo "$FIRST_BLOCK" \
  | grep -m1 'action:' \
  | sed 's/.*action:[[:space:]]*//;s/[",]//g')
step_action=${step_action:-apply}

echo "[INFO] Paso: $step_name"
echo "[INFO] Dir : $step_dir"
echo "[INFO] Act : $step_action"

# --- Validaciones ---
[[ -d $step_dir ]] || { echo "[ERROR] No existe directorio '$step_dir'"; exit 1; }

# --- Ejecutar Terraform ---
pushd "$step_dir" >/dev/null
echo "[INFO] cd $step_dir && $TERRAFORM_CMD init"
$TERRAFORM_CMD init -input=false -no-color -upgrade
echo "[INFO] cd $step_dir && $TERRAFORM_CMD $step_action $AUTO_APPROVE_FLAG"
$TERRAFORM_CMD "$step_action" $AUTO_APPROVE_FLAG
popd >/dev/null

echo "[INFO] ¡Paso completado!"
