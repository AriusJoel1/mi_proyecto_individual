# Builder

El patrón Builder permite crear objetos complejos paso a paso, separando cómo se construyen de cómo se ven al final.
Un componente ``builder`` define una serie de pasos para configurar el objeto.
Un componente adicional ``director`` orquesta esos pasos en un orden predefinido para producir una variante específica del objeto.
El ``builder`` retiene el estado parcial durante el proceso, y un método final ``build`` genera el objeto construido.
Esto permite distintas variantes del mismo objeto, mejora la legibilidad y evita constructores con demasiados parámetros.

### Variables

```json
variable "env_name" {
  type        = string
  default     = "Ubuntu VM"
  description = "Nombre del entorno."
}
```

```json
variable "env_type" {
  type        = string
  default     = "Ubuntu"
  description = "Tipo del entorno."
}
```

```json
variable "env_count" {
  type        = number
  default     = 5
  description = "Cantidad de entornos a crear."
}
```

### Outputs

```json
output "create_builder" {
  value       = "Creados ${var.env_count}
```

## Ejemplo de invocacion

```bash
cd ./iac_patterns/builder
terraform init
terraform apply -auto-approve
```
