# Factory

El patrón Factory encapsula la creación de objetos, delegando esta responsabilidad a una función o clase que decide qué objeto devolver según ciertos parámetros.
Su propósito es desacoplar la lógica de construcción del código cliente. Con esto se evita dependencias directas con clases concretas y facilita la extensibilidad del sistema.

> Una nota adicional es que este patrón es un gran ejemplo de aplicación del principio de inversión de dependencia (DIP).

### Variables

```json
variable "resource_type" {
  type        = string
  description = "Tipo de recurso a crear ('local', 'web', 'VM')."
  default     = "local"
}
```

```json
variable "product_count" {
  type        = number
  description = "Cantidad de recursos a crear."
  default     = 1
}
```

### Outputs

```json
output "create_resource" {
  value       = var.resource_type
  description = "Tipo de recurso generado por la fábrica."
}
```

## Ejemplo de invocacion

```bash
cd ./iac_patterns/factory
terraform init
terraform apply -auto-approve
```
