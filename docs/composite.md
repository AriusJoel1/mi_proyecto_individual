# Composite

El patrón Composite permite tratar objetos individuales y compuestos de la misma forma.
Su implementación se basa en una clase que almacena elementos hijos en una relación ``has-a``, los cuales pueden ser objetos simples o nuevas composiciones, formando una estructura jerárquica arbórea donde las hojas son objetos simples y las ramas son las composiciones. Gracias a esta estructura, el patrón se propaga recursivamente sin que haya necesidad de distinguir entre hojas o ramas.
Este patrón es útil cuando queremos operar de la misma forma sobre componentes simples y sobre los compuestos, delegando en cada nodo el trabajo sobre sus propios componentes.

### Variables

```json
variable "parent_name" {
  type        = string
  description = "Nombre del recurso padre"
  default     = "RecursoPadre"
}
```

```json
variable "child_count" {
  type        = number
  description = "Cantidad de recursos hijo a crear."
  default     = 5
}
```

### Outputs

```json
output "generate_structure" {
  value       = "Padre: ${var.parent_name}
```

## Ejemplo de invocacion

```bash
cd ./iac_patterns/composite
terraform init
terraform apply -auto-approve
```
