# Variables
RELEASE ?= v0.1
DNS_SERVER ?= 8.8.8.8
TARGETS ?= ejemplo.com

# Targets
.PHONY: help tools build clean install-service start-service stop-service

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

# Ejecuta pruebas con Bats
test:
	@bats tests

# Genera un paquete tar.gz en dist/
pack: build
	@mkdir -p dist
	tar -czf dist/app-$(RELEASE).tar.gz src/ docs/ tests/
	@echo "Paquete generado en dist/app-$(RELEASE).tar.gz"

# Limpia las carpetas out
clean:
	@rm -rf out
	@echo "Carpeta out/ limpiada"

# Instala el servicio systemd
install-service: build
	@echo "Instalando servicio systemd..."
	@sed 's|{{PROJECT_DIR}}|$(PWD)|g' systemd/app.service > out/app.service
	@sed -i 's|Environment=PORT=8080 MESSAGE=Hola_desde_systemd|Environment=PORT=$(PORT) MESSAGE=$(MESSAGE)|g' out/app.service
	@sudo cp out/app.service /etc/systemd/system/
	@sudo systemctl daemon-reload
	@echo "Servicio instalado. Use 'make start-service' para iniciarlo"

# Inicia el servicio systemd
start-service:
	@echo "Iniciando servicio"
	@sudo systemctl enable app
	@sudo systemctl start app
	@echo "Servicio iniciado."

# Detiene el servicio systemd
stop-service:
	@echo "Deteniendo servicio"
	@sudo systemctl stop app
	@echo "Servicio detenido."

# Muestra los targets disponibles
help:
	@echo "Targets disponibles:"
	@echo "  tools	: Verifica las dependencias necesarias"
	@echo "  build	: Prepara los artefactos en out/"
	@echo "  run	: Ejecuta el flujo principal"
	@echo "  test   : Ejecuta pruebas con Bats"
	@echo "  pack   : Genera paquete reproducible en dist/"
	@echo "  clean	: Borra out/ y dist/"
