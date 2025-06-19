# Prototype

El patrón Prototype crea nuevos objetos clonando otros existentes, en lugar de generarlos directamente.
Cada prototipo expone un método ``clone`` que copia su estado interno.
Es especialmente útil cuando la construcción manual es costosa o queremos replicar estructuras configuradas previamente sin repetir la lógica de inicialización.
