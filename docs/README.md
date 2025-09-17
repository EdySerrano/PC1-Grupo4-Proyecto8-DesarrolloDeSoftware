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

## Variables de entorno (contrato)
Las siguientes variables controlan el comportamiento del sistema.  

| Variable     | Descripción | Efecto observable |
|--------------|-------------|-------------------|
| `PORT`       | Puerto TCP a exponer | El servidor/monitor se inicia en ese puerto. |
| `MESSAGE`    | Mensaje de salida o banner | Se imprime al ejecutar `make run`. |
| `RELEASE`    | Versión de la build | Nombrado del paquete en `dist/` (`app-$(RELEASE).tar.gz`). |
| `DNS_SERVER` | Servidor DNS a consultar | `dig` y chequeos DNS se ejecutan contra este servidor. |
| `TARGETS`    | Servicios o endpoints a validar | Scripts de chequeo procesan estos destinos. |


## Bitacora:

### Sprint 1:
**Actividades realizadas**

- Creación de la estructura mínima del repositorio (src/, tests/, docs/, out/, dist/).
- Implementación del Makefile con targets básicos (tools, build, test, run, pack, clean, help).
- Desarrollo de los primeros scripts en src/ para chequeos HTTP y DNS.
- Configuración de variables de entorno iniciales (PORT, MESSAGE, DNS_SERVER, TARGETS).
- Creación de un caso de prueba representativo en tests/ usando Bats.
- Documentación inicial en docs/README.md.

**Evidencias**

- Ejecución de `make tools` detectando utilidades clave.
- Ejecutando `make test` y mostrando salida exitosa de la primera prueba Bats.
- **Video**: **[Sprint-1](https://youtu.be/cG1d33lRaeU)**

**Roles**

* **Hinojosa Frank**: Makefile inicial y targets básicos.
* **Serrano Edy**: Script de chequeo HTTP/DNS.
* **Choquecambi Germain**: Prueba inicial con Bats.

### Sprint 2:
**Actividades realizadas**

- Mejora de scripts Bash con manejo de errores (set -euo pipefail) y trap para limpieza en caso de fallos.
- Implementación de pipelines con utilidades Unix (grep, cut, tr, awk).
- Manejo de señales de proceso (SIGINT, SIGTERM) para detener ejecución limpiamente.
- Ampliación de la matriz de pruebas en tests/ con más casos Bats.

**Evidencias**

- systemctl --user start app.service funcionando y registrado en journalctl.
- Script monitor respondiendo a señales con limpieza automatica.
- Pruebas Bats ampliadas mostrando mas cobertura.
- **Video**: **[Sprint-2](https://youtu.be/S9YpaknFYeI)**

**Roles**

- **Serrano Edy**: Robustecimiento de Bash + trap + pipelines.
- **Hinojosa Frank**: Señales de proceso + metricas.
- **Choquecambi Germain**: Ampliación de pruebas Bats + documentación de metricas.

### Sprint 3:
**Actividades realizadas**

- Integración de todos los scripts y pruebas en un flujo consistente.
- Empaquetado reproducible en dist/ con nombre basado en RELEASE.
- Validación de idempotencia: ejecutar dos veces produce mismos resultados.
- Validación de trazabilidad: logs y salidas intermedias en out/.
- Preparación de changelog y Pull Request final hacia main.

**Evidencias**

- `make pack` generando paquete `.tar.gz` con versión exacta del `RELEASE`.
- `make run` ejecutado dos veces con salida idéntica.
- Logs de ejecucion documentados en docs/README.md.
- **Video**: **[Sprint-3](https://youtu.be/2aumaIAaeAY)**

**Roles**

- **Serrano Edy**: Mejora del Makefile + validaciones de idempotencia + Documentacion del README.
- **Hinojosa Frank**: Empaquetado reproducible en dist/ + contrato de salida + PR de cierre.
- **Choquecambi Germain**: Integracion de pruebas finales.

## Instruciones de uso:

| Target              | Descripción                                      |
|---------------------|--------------------------------------------------|
| `make tools`             | Verifica las dependencias necesarias             |
| `make build`             | Prepara los artefactos en `out/`                 |
| `make run`               | Ejecuta el flujo principal                       |
| `make run-service`       | Ejecuta el servicio runner en primer plano        |
| `make test`              | Ejecuta pruebas con Bats                         |
| `make pack`              | Genera paquete reproducible en `dist/`           |
| `make validar`             | Valida la idempotencia                          |
| `make clean`             | Borra `out/` y `dist/`                           |
|                     |                                                  |
| **Gestión de servicio systemd** |                                      |
| `make install-service`   | Instala el servicio en systemd                    |
| `make uninstall-service` | Desinstala el servicio de systemd                 |
| `make start-service`     | Inicia el servicio                               |
| `make stop-service`      | Detiene el servicio                              |
| `make status-service`    | Muestra estado y logs del servicio                |

## Ramas:
**Sprint-1:**
- **Hinojosa Frank:** [build-rules/make-basico](https://github.com/EdySerrano/PC1-Grupo4-Proyecto8-DesarrolloDeSoftware/tree/build-rules/make-basico)
- **Choquecambi Germain:** [checks/test-http](https://github.com/EdySerrano/PC1-Grupo4-Proyecto8-DesarrolloDeSoftware/tree/checks/test-http)
- **Serrano Edy:** [checks/http-y-dns-cheks](https://github.com/EdySerrano/PC1-Grupo4-Proyecto8-DesarrolloDeSoftware/tree/checks/http-y-dns-checks)

**Sprint-2:**
- **Hinojosa Frank:** [frank-hinojosa/administrador-proceso](https://github.com/EdySerrano/PC1-Grupo4-Proyecto8-DesarrolloDeSoftware/tree/frank-hinojosa/administrador-proceso)
- **Choquecambi Germain:** [Germain-Choquechambi/mejora-test](https://github.com/EdySerrano/PC1-Grupo4-Proyecto8-DesarrolloDeSoftware/tree/Germain-Choquechambi/mejora-test)
- **Serrano Edy:** [Edy-Serrano/mejora de bash](https://github.com/EdySerrano/PC1-Grupo4-Proyecto8-DesarrolloDeSoftware/tree/Edy-Serrano/mejora-de-bash)

**Sprint-3:**
- **Hinojosa Frank:** [frank-hinojosa/make-reproducible](https://github.com/EdySerrano/PC1-Grupo4-Proyecto8-DesarrolloDeSoftware/tree/frank-hinojosa/make-reproductible)
- **Choquecambi Germain:** [Germain-Choquechambi/test-idempotencia-pack-check](https://github.com/EdySerrano/PC1-Grupo4-Proyecto8-DesarrolloDeSoftware/tree/Germain-Choquechambi/test-idempotencia-pack-check)
- **Serrano Edy:** [Edy-Serrano/Validacion-de-idempotencia](https://github.com/EdySerrano/PC1-Grupo4-Proyecto8-DesarrolloDeSoftware/tree/Edy-Serrano/Validacion-de-idempotencia)

## Tablero Kanban:
En este proyecto de utilizo el Tablero Kanban lo que facilito el registro y procedimiento en cada etapa del desarrollo el proyecto, en donde se registraron [Las historias de usuario](https://github.com/EdySerrano/PC1-Grupo4-Proyecto8-DesarrolloDeSoftware/issues?q=is%3Aissue%20state%3Aclosed) especificando lo que se va implementar y luego de eso realizar el [Pull Request](https://github.com/EdySerrano/PC1-Grupo4-Proyecto8-DesarrolloDeSoftware/pulls?q=is%3Apr+is%3Aclosed) para la revision de los demas integrantes y asi practicar una metodologia Agil.

Link Tablero Kanban : [PC1-Builder de apps seguras con Makefile](https://github.com/users/EdySerrano/projects/3)
