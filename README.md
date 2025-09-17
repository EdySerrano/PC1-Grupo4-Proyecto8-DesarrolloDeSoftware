# PC1-Grupo4-Proyecto8-DesarrolloDeSoftware

## Equipo 4:

| Miembro del Equipo | Codigo |
| :----------------- | :-------------------- |
| **Choquecambi Germain** | `20211360A` |
| **Serrano Edy** | `20211229B` | 
| **Hinojosa Frank** | `20210345I`  | 

## Descripcion

**Builder de apps seguras con Makefile** (**[Repositorio](https://github.com/EdySerrano/PC1-Grupo4-Proyecto8-DesarrolloDeSoftware)**), nuestro objetivo es construir un sistema automatizado para el desarrollo de aplicaciones seguras utilizando Makefile como herramienta principal de orquestacion. Buscaremos integrar conceptos de redes (**HTTP, DNS, TLS**), practicas de **12-Factor App**, y el principio **You Build It, You Run It**, permitiendo una responsabilidad del equipo tanto en el desarrollo como en la ejecución de la aplicacion.

### Estructura del proyecto:
```
proyecto8-builder/
├── docs/               # Documentación y bitácoras
│   └── README.md       # Instrucciones, variables de entorno y contrato de 
├── src/                # Scripts en Bash
│   ├── checks.sh      
│   ├── runner.sh      
│   └── validar.sh  
│     
├── systemd/            # Unidad de servicio minima
│   └── app.service
│
├── tests/              # Pruebas automatizadas con Bats
│   └── tests_basico.bats
│
├── out/                # Salidas intermedias (logs, dumps, temporales)
│
├── dist/               # Paquetes reproducibles
│
├── Makefile            # Flujo principal (tools, build, test, run, pack, clean, help, etc)
│
└── .gitignore          # Ignorar archivos temporales y cache
```
