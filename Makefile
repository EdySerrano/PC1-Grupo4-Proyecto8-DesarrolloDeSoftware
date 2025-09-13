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