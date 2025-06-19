#!/usr/bin/env bash

set -e

# --- Configuración ---
PATTERNS=(builder singleton composite factory prototype)
SRC_DIR="./iac_patterns"
VENV_DIR=".venv"
REQUIREMENTS="requirements.txt"
HOOKS_DIR="git-hooks"

# --- Uso del script ---
help_view() {
    echo "Uso: $0 --pattern <patron>"
    exit 1
}

# inicialización del entorno
setup_venv() {
  cd ..
    if [[ ! -d "$VENV_DIR" ]]; then
        echo " Creando entorno ..."
        python -m venv "$VENV_DIR"
        source "$VENV_DIR/Scripts/activate"
        if [[ -f "$REQUIREMENTS" ]]; then
            pip install -r "$REQUIREMENTS"
        fi
        deactivate
    fi
}
# configuración de hooks
setup_hooks() {
    if [[ ! -d ".git" ]]; then
        echo "No es un repositorio git."
        exit 1
    fi
    git config core.hooksPath "$HOOKS_DIR"
}
# patrón existente
run_pattern() {
    local pattern="$1"
    local dir="$SRC_DIR/$pattern"
    case "$pattern" in
        builder)
            (cd "$dir"
            terraform init
            terraform apply -auto-approve
            ./builder.sh)
            ;;
        singleton)
            (cd "$dir"
            terraform init
            terraform apply -auto-approve
            cd scripts
            ./singleton.sh)
            ;;
        composite)
            (cd "$dir"
            terraform init
            terraform apply -auto-approve
            ./run.sh)
            ;;
        factory)
            (cd "$dir"
            terraform init
            terraform apply -auto-approve
            ./run_factory.sh)
            ;;
        prototype)
            (cd "$dir"
            terraform init
            terraform apply -auto-approve
            cd scripts
            python clone_prototype.py)
            ;;
        *)
            echo "Patrón no encontrado."
            help_view
            exit 1
            ;;
    esac
}

# --- Main ---
if [[ "$1" != "--pattern" || -z "$2" ]]; then
    help_view
fi

PATTERN="$2"
if [[ ! " ${PATTERNS[*]} " =~ " $PATTERN " ]]; then
    echo "Patrón inválido: $PATTERN"
    help_view
fi

FIRST_RUN_FLAG=".setup_done"
if [[ ! -f "$FIRST_RUN_FLAG" ]]; then
    setup_venv
    setup_hooks
    touch "$FIRST_RUN_FLAG"
fi

run_pattern "$PATTERN"