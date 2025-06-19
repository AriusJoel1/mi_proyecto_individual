# Builder

El patrón Builder permite crear objetos complejos paso a paso, separando cómo se construyen de cómo se ven al final.
Un componente ``builder`` define una serie de pasos para configurar el objeto.
Un componente adicional ``director`` orquesta esos pasos en un orden predefinido para producir una variante específica del objeto.
El ``builder`` retiene el estado parcial durante el proceso, y un método final ``build`` genera el objeto construido.
Esto permite distintas variantes del mismo objeto, mejora la legibilidad y evita constructores con demasiados parámetros.
