# Composite

El patrón Composite permite tratar objetos individuales y compuestos de la misma forma.
Su implementación se basa en una clase que almacena elementos hijos en una relación ``has-a``, los cuales pueden ser objetos simples o nuevas composiciones, formando una estructura jerárquica arbórea donde las hojas son objetos simples y las ramas son las composiciones. Gracias a esta estructura, el patrón se propaga recursivamente sin que haya necesidad de distinguir entre hojas o ramas.
Este patrón es útil cuando queremos operar de la misma forma sobre componentes simples y sobre los compuestos, delegando en cada nodo el trabajo sobre sus propios componentes.
