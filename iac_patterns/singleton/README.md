# Singleton

El patrón Singleton garantiza que un componente solo pueda generar un objeto una vez, y que este objeto sea accesible globalmente.
Lo implementamos controlando la creación del objeto desde un método de clase que retorna siempre la misma referencia, bien creando el objeto, bien retornando el que ya fue creado.
El propósito de este patrón es centralizar recursos compartidos (como configuración o logs), encapsulando la lógica de creación y evitando duplicados que pueden producir inconsistencias.
