# Proyecto 3: "Diseño y compartición de módulos IaC con patrones de software"

* Alumno: Joel Benjamin Seminario Serna
* Código: 20210056G
* Correo institucional: joel.seminario.s@uni.pe
* Enlace del repositorio grupal: https://github.com/AldoLunaBueno/pc3-grupo4-tema3

## Videos:
* Carpeta de videos: https://drive.google.com/drive/folders/1CUutRnTIzWAknSoB_-XgzQaUSUGRAMYS?usp=sharing

* SPRINT 1: https://drive.google.com/file/d/1oBB9UcbU-Iwh9y_WIxMDJC0kj0uLmSrz/view?usp=sharing

* SPRINT 2: https://drive.google.com/file/d/1pptNl_6JbkkrDTkemTHytNa8_m734Ak3/view?usp=sharing

* SPRINT 3: https://drive.google.com/file/d/1I7ZWoMH9waNKvGnjbQ_z2kzV3Jjyk3XV/view?usp=sharing


En el sprint 1, mi rol fue como DevOps donde generé el script generar_diagramas.py con una estructura base como punto de partida para la futura generación de diagramas. Además se le agrego dicho script una prueba automatica utilizando pytest para verificar su correcto funcionamiento desde una etapa temprana. Tambien configuré los archivos .gitignore, .flake8, .bandit  e implementé el script main.sh para ejecutar el patrón correspondiente.

Para el sprint 2 y 3 mi rol fue de desarrollador, aunque tambien tuve un enfoque en la documentacion el patrón Builder y asegure buenas practicas colaborativa mediante un hook. Realize la combinacion de patrones (Factory dentro de Builder) y mejoré la estructura del modulo Builder. Ademas implemente scripts de pruebas para validar el correcto despliegue de dichos módulos.


## Instalación

``` 
git clone https://github.com/AldoLunaBueno/pc3_repo_individual
cd pc3_repo_individual
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Ejecución de scripts

* Módulo Builder
``` 
cd .\iac_patterns\builder\
terraform init
terraform apply -auto-approve 
terraform apply -var-file="builder_inputs.tfvars"
``` 

* Módulo Factory
``` 
cd .\iac_patterns\factory\
terraform init
terraform apply
#Enter a value: 
local_file 
#Enter a value: 
yes
#de manera personalizada:
terraform apply -var="factory_type=local_file" -var="file_name=archivo.txt" -var="file_content=Hola desde la fábrica de Terraform"
``` 

* Scripts 
``` 
cd .\scripts\
py .\generate_diagram.py -p singleton
#obs: ... el script aún no implementa la generación del archivo .dot, por lo que solo ejecuta la fase inicial de procesamiento sin producir el grafo DOT.
``` 

* Tests
```
cd .\tests\
py.test.exe
```

## Videos Grupales:
#### Sprint 1

[Link Video del Sprint_1-Grupo3](https://drive.google.com/file/d/1ZWNHv99Dbc8p1jF8iGqgm0_ftpk_M3Xp/view?usp=sharing)

