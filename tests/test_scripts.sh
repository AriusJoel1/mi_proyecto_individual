#!/usr/bin/env bash

set -e

# ruta relativa
SCRIPTS_DIR="../scripts"
SCRIPTS=(
    "generate_diagram.py"
    "generate_documentation.py"
    "verify_ia_docs.py"
    "verify_state.py"
)

cd "$(dirname "$0")"

echo "Verificando errores de seguridad y sintaxis..."

for script in "${SCRIPTS[@]}"; do
    SCRIPT_PATH="$SCRIPTS_DIR/$script"
    echo "Pruebas para $script"
    echo ">> flake8:"
    flake8 "$SCRIPT_PATH"
    echo ">> bandit:"
    bandit -r "$SCRIPT_PATH"
    echo "Estado de ${script}: OK"
done