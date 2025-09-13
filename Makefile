# Variables
RELEASE ?= v0.1
DNS_SERVER ?= 8.8.8.8
TARGETS ?= ejemplo.com

# Targets
.PHONY: help tools build clean

# Muestra las herramientas necesarias
tools:
	@command -v curl >/dev/null || (echo "Falta curl" && exit 1)
	@command -v dig >/dev/null || (echo "Falta dig" && exit 1)
	@command -v bats >/dev/null || (echo "Falta bats" && exit 1)
	@echo "Todas las herramientas disponibles"

# Crea la carpeta out y prepara los artefactos
build:
	@mkdir -p out
	@echo "Build basico completado"

# Ejecuta el flujo principal
run:
	@bash src/checks.sh

# Limpia las carpetas out
clean:
	@rm -rf out
	@echo "Carpeta out/ limpiada"

# Muestra los targets disponibles
help:
	@echo "Targets disponibles:"
	@echo "  tools	: Verifica las dependencias necesarias"
	@echo "  build	: Prepara los artefactos en out/"
	@echo "  run	: Ejecuta el flujo principal"
	@echo "  clean	: Borra out/ y dist/"
