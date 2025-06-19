output "product_details" {
  description = "Detalles del recurso creado por la fábrica."
  value = {
    type_created = var.factory_type
    id = try(
      one(
        concat(
          local_file.product_file.*.id,
          [for r in random_id.product_id : "${var.id_prefix}${r.hex}"]
        )
      ),
      "N/A (recurso no creado para este tipo)"
    )
    details = try(
      one(
        concat(
          [for f in local_file.product_file : "Archivo creado en: ${f.filename}"],
          [for r in random_id.product_id : "ID aleatorio (hex): ${var.id_prefix}${r.hex}"]
        )
      ),
      "N/A (recurso no creado para este tipo)"
    )
  }
}

output "product_summary" {
  description = "Resumen simple del recurso creado."
  value = try(
    one(
      concat(
        [for f in local_file.product_file : "Archivo generado: ${f.filename}"],
        [for r in random_id.product_id : "ID generado: ${var.id_prefix}${r.hex}"]
      )
    ),
    "Ningún recurso fue generado."
  )
}
