# Singleton

El patrón Singleton garantiza que un componente solo pueda generar un objeto una vez, y que este objeto sea accesible globalmente.
Lo implementamos controlando la creación del objeto desde un método de clase que retorna siempre la misma referencia, bien creando el objeto, bien retornando el que ya fue creado.
El propósito de este patrón es centralizar recursos compartidos (como configuración o logs), encapsulando la lógica de creación y evitando duplicados que pueden producir inconsistencias.

### Variables

```json
variable "instance_name" {
  type        = string
  description = "Nombre de la instancia."
  default     = "test-singleton"
}
```

```json
variable "instance_type" {
  type        = string
  description = "Tipo de instancia."
  default     = "basic"
}
```

### Outputs

```json
output "create_instance" {
  value       = "Recurso ${var.instance_name}
```

## Ejemplo de invocacion

```bash
cd ./iac_patterns/singleton
terraform init
terraform apply -auto-approve
```

- **Verificacion de instancia creada**

```bash
# en ./iac_patterns/singleton
cd scripts
chmod +x singleton.sh
./singleton.sh
```
