# Proyecto 3: "Diseño y compartición de módulos IaC con patrones de software"

---

## Instalación

El primer paso es obtener este repositorio con todos los contenidos necesarios. Para esto no basta clonar, también es necesario obtener los submódulos:

```bash
git clone --recurse-submodules https://github.com/AldoLunaBueno/pc3-grupo4-tema3.git
```

El segundo paso es asegurarte de que tienes Python (>=3.10) y Terraform (>=1.2) instalados, y que en tu entorno puedes usar Bash.

## Índice

- [Código principal](#archivo-mainsh)
- [Herramientas usadas](#herramientas-usadas)
- [Git Hooks](#git-hooks)
- [Scripts generales](#scripts-generales)
- [Patrones de diseño](#patrones-de-diseño)
  - [Singleton](#singleton)
  - [Prototype](#prototype)
  - [Builder](#builder)
  - [Composite](#composite)

## Videos

[Link Video del Sprint_1-Grupo3](https://drive.google.com/file/d/1ZWNHv99Dbc8p1jF8iGqgm0_ftpk_M3Xp/view?usp=sharing)

## Sprint 1

## Archivo `main.sh`

Archivo que automatiza la ejecución de todo el proyecto, dentro de sus funciones está lo siguiente:

* Si es ejecutado por primera vez:

  * Crea y activa el entorno virtual `.venv`.
  * Instala las dependencias.
  * Activa los hooks dentro de `git-hooks/`.

* Desde la segunda ejecución:

  * Acciona el patrón puesto.
  * limpia el estado.

```bash
cd scripts
source ./main.sh --pattern <nombre-patrón>
```

## Herramientas usadas

### 1. flake8, bandit

* **flake8**: Verifica código en Python por incorrecta sintáxis y malas prácticas.
* **bandit**: Analisa código en Python por posibles errores de seguridad.

```bash
flake8 -r scripts/
bandit -r scripts/
```

### 2. Pytest

Framework de pruebas para python, usado para asegurar buenas pruebas en los scripts `verify_state.py`, `generate_documentation.py`, `generate_diagram.py`, `etc`.

## Git Hooks

Tomamos la decisión de versionar los hooks para que sean más trazables y más fáciles de obtener (con git pull).

Para esto, los hooks no están en la ruta habitual `.git/hooks`, donde no se puede versionar nada, sino en `git-hooks`. Queremos que cada colaborador pueda usar estos hooks, pero Git no sabe automáticamente cuál es el nuevo directorio que queremos usar para ellos, así que se lo decimos con el siguiente comando:

```bash
git config core.hooksPath git-hooks
```

**Todos los colaboradores debemos correr este comando en nuestro repositorio local** para que los hooks funcionen y nos ayuden a no incurrir en inconsistencias en nuestros commits. Veremos más en detalle qué hace cada hook definido en [git-hooks](./git-hooks/).

### commit-msg

Este hook nos ayuda a que cada mensaje de commit sea claro. La validación se hace con base en la convención [Conventional commits](https://www.conventionalcommits.org/en/v1.0.0/). No implementamos todos los casos posibles, pero sí los más importantes. Para empezar, todos los commits deben seguir esta estructura:

```txt
<type>[optional scope]: <description>

[optional body]
```

Validamos tres puntos:

1. El campo ``type`` debe ser un tipo especificado en *Conventional commits*.
2. El campo ``scope`` es opcional, pero no se pueden dejar paréntesis vacíos.
3. El título del commit (la primera línea) no debe exceder los 72 caracteres (buena práctica no especificada en el documento oficial)

También se deja lugar para un cuerpo opcional para el mensaje del commit.

### pre-commit

Este hook verifica la rama sobre la que estamos haciendo commit. No se permite hacer commit sobre una rama que no siga las convenciones de ramificación usadas para este proyecto. Por ejemplo, impide que se pueda hacer un commit sobre ``main``. Actualmente, seguimos el patrón de ``Continuous Integration``, así que **solo hacemos commits sobre ramas feature/\*, hotfix/\* y docs/\***.

## Submodulos

Generación de submodulos para simular uso de futuros módulos externalizados.

---

## Sprint 2

## Scripts generales

### 1. `generate_diagram.py`

Genera diagramas para cada módulo.

### 2. `generate_documentation.py`

Genera la documentación de cada patrón de diseño **(singleton, composite, builder, prototype y factory)**.

* Está dividido de la siguiente forma:

```bash
  <Titulo>
  <Índice>
  <Descripción-breve>
  <Variables>
  <Outputs>
  <Ejecución-ejemplo>
```

### 3. `verify_ia_docs.py`

Script que usa una lista de frases genéricas para verificar el porcentaje de texto copiado de páginas web, articulos, etc.

### 4. `verify_state.py`

Script que genera un archivo **.json** para mostrar el estado de cada módulo.

> Más información de los
> scripts en los comentarios de cada código: [Ver carpeta scripts](./scripts/)

## Sprint 3

## Patrones de diseño

### Singleton

Este módulo se encarga de la creación de una instancia única de un recurso, esta puede ser llamada desde diferentes módulos (**globalizada**) y solo puede instanciarse una vez durante el ciclo de vida de la infraestructura.

#### Ejecución

```bash
cd scripts # en carpeta raiz
# Llamado al módulo singleton
./main.sh --pattern singleton
```

#### Pruebas de integración

```bash
cd iac_patterns/singleton/scripts
./test_module_singleton.sh
```

#### 1. `variables.tf`

Define las variables de entrada para la generación del recurso.

* `instance_name`: nombre de la instancia.

* `instance_type`: tipo de instancia.

* `instance_enabled`: variable booleana que revisa si la instancia está o no habilitada.

#### 2. `main.tf`

Ejecuta un script para controlar la creación de la instancia.

* Crea un recurso nulo que **representará** la creación de una **instancia**.
* Acciona triggers:
  * por cada variable (`instance_name` e `instance_type`) revisa cambios para accionar el trigger.
  * Crea un `tag` para asegurar la existencia del lock cada que se accione el script `test_module_singleton.sh`
* Ejecuta el script `singleton.sh` dentro de un provisioner generando un `instance.lock`.

#### 3. `outputs.tf`

* `create_instance` muestra si la instancia está **habilitada** o **deshabilitada**.

* `singleton_status` muestra el el estado de creación del módulo.

#### Scripts

#### 1. `singleton.sh`

Script en bash que crea un archivo lock para asegurar una única instancia creada.

* `LOCK_FILE` evita la creación de múltiples instancias simultaneas.
* `PID_FILE` guarda el PID del proceso actual.
  * Si este `PID` ya existe, ejecuta un mensaje de instancia existente.
  * Si no existe el `lock`, lo crea y muestra su creación.
* Limpia el `PID` al finalizar la ejecución del script.

#### 2. Pruebas de integración: `test_module_singleton.sh`

* Verifica la creación de `singleton.lock`.

* Verifica que el `output` se ejecute correctamente.

### Prototype

Este módulo genera archivos de infraestructura a base de una plantilla modificable (`example.tf`), y ejecuta el script `clone_prototype (count = n)` para crear **N** clones a base de dicha plantilla con pequeñas modificaciones en su estructura.

#### Ejecución

```bash
cd scripts # en carpeta raiz
# Llamado al módulo prototype
./main.sh --pattern prototype
```

#### Pruebas de integración

```bash
cd iac_patterns/prototype/scripts
./test_module_prototype.sh
```

#### 1. `variables.tf`

Define las variables de entrada para la generación del archivo principal de la creación del prototypo.

* `name`: nombre del recurso creador del prototipo

* env`: variable de ejemplo para denotar un entorno dentro del recurso.

#### 2. `main.tf`

* `create_prototype`: mensaje de creación del clón a base de la plantilla dada.

* Se configura los **providers** necesarios para trabajar con archivos locales, plantillas, archivos nulos y aleatorios.

* Con un local_file procesa la plantilla y la guarda en un archivo `example.tf`.

* Cambia el contenido de la plantilla (`env` y `name`) para generar archivos .

#### 3. `outputs.tf`

* `create_prototype`: mensaje de creación del clón a base de la plantilla dada.

#### Scripts

##### 1. `clone_prototype.py`

Script hecho para crear **N** clones a base de la plantilla `prototype.hcl.tpl`, como ejemplo se tiene la creación de solo 3 clones.

##### 2. `test_module_prototype.sh`

* Valida la correcta creación de la infraestructura.

* Revisa que los outputs sean los correctos.

* pasa las pruebas de sintaxis para terraform(`tflint`)

### Builder

#### 1. `build_config.yaml`

Automatiza la ejecución secuencial de módulos definidos en build_config.yaml

* `global_settings:`: Ajusta el comando Terraform (`terraform_command`) y el flag `-auto-approve`.  
* `build_steps:`: Es la lista de pasos con:
  * `name`, `directory` y `action`
  * Bloques `variables:` que se convierten en `-var="clave=valor"` .

#### 2. `main.tf`

Orquesta `null_resource` con triggers y dependencias:

* `step1_initialize_env`: Inicializa el entorno base según configuración e incluye timestamp() para volver a ejecutar.

* `step2_configure_network` : Configura la red con el cidr_block y número de subredes.

* `step3_deploy_app` : Despliega la aplicación con nombre y versión especificados; depende de step2.

#### 3. `builder.sh`

Lee `build_config.yaml` y ejecuta cada paso secuencialmente:

* Parseo de `global_settings:` para ajustar `TERRAFORM_CMD` y `AUTO_APPROVE_FLAG`.  
* Extracción de `build_steps:` con recuento de pasos y lectura de variables.  
* Para cada paso:
  1. `terraform init` (con reintentos silenciosos).  
  2. Genera argumentos `-var="clave=valor"` y lanza `terraform <action>`.  
  3. Imprime `[BUILD_SCRIPT_INFO]` o `[BUILD_SCRIPT_ERROR]` según el resultado.  

### Ejecución

```bash
bash builder.sh
# o
main.sh --pattern builder
```

### Factory

### Composite

Este módulo ejemplifica el patrón de diseño Composite. Muestra cómo se pueden usar módulos para componer estructuras arbitrariamente profundas. Pese a todo el esfuerzo, hay dos consideraciones importantes en este caso:

1. Es una práctica desaconsejada crear árboles de una profundida mayor a 2.
2. Terraform aún no tiene la capacidad de generar estructuras modulares recursivas dinámicamente, como es natural en el patrón Composite.

El segundo punto limitó bastante poder representar fielmente el patrón. Existen alternativas, como crear los archivos y carpetas dinámicamente usando scripts de Python o Bash, pero en este proyecto no se requería esto.

#### Estructura

- `main.tf`: módulo raíz que ejecuta la tarea principal y delega en submódulos.
- `modules/subtask1`, `modules/subtask2`: módulos reutilizables que pueden activarse o no.

#### Variables

- `name`: nombre del recurso padre.
- `enable_subtask1`, `enable_subtask2`: habilita los submódulos.
- `task_priority`, `task_description`: atributos adicionales de cada subtarea.

#### Outputs

- `generate_structure`: muestra cuántas subtareas fueron creadas.
- `subtask_count`, `task_priority`, `task_description`: generados por cada submódulo.
