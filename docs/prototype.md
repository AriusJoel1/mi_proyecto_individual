# Prototype

El patrón Prototype crea nuevos objetos clonando otros existentes, en lugar de generarlos directamente.
Cada prototipo expone un método ``clone`` que copia su estado interno.
Es especialmente útil cuando la construcción manual es costosa o queremos replicar estructuras configuradas previamente sin repetir la lógica de inicialización.

### Variables

```json
variable "name" {
  type    = string
  default = "mi_clon"
}
```

```json
variable "env" {
  type    = string
  default = "entorno_basico"
}
```

### Outputs

```json
output "create_clon" {
  value = "Prototipo generado con exito."
}
```

## Ejemplo de invocacion

- **Generas el prototipo a base de la plantilla ubicada en `./prototype/templates`**

```bash
cd ./iac_patterns/prototype
terraform init
terraform apply -auto-approve
```

- **A base de esta plantilla se generan clones.**

```bash
# en ./iac_patterns/prototype
cd scripts
# crea 1 clon
python clone_prototype.py
```
