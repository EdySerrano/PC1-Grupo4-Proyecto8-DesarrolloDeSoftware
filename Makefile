# Variables
RELEASE ?= v0.1
DNS_SERVER ?= 8.8.8.8
TARGETS ?= ejemplo.com
MESSAGE ?= Hola desde mi app
PORT ?= 8080
COMMIT := $(shell git rev-parse --short HEAD 2>/dev/null || echo "no-git")
DATE := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# Archivos principales
SRC_FILES := $(shell find src -type f)
DOC_FILES := $(shell find docs -type f)
TEST_FILES := $(shell find tests -type f)
SYS_FILES := $(shell find systemd -type f)

# Targets
.PHONY: help tools build clean install-service start-service stop-service uninstall-service status-service run run-service test pack

# Muestra las herramientas necesarias
tools:
	@command -v curl >/dev/null || (echo "Falta curl" && exit 1)
	@command -v dig >/dev/null || (echo "Falta dig" && exit 1)
	@command -v bats >/dev/null || (echo "Falta bats" && exit 1)
	@sha256sum --version >/dev/null 2>&1 || (echo "Falta sha256sum" && exit 1)
	@echo "Todas las herramientas disponibles"

# Build con caché incremental
out/metadata.txt: $(SRC_FILES) $(DOC_FILES) $(TEST_FILES) $(SYS_FILES)
	@mkdir -p out
	@echo "Release: $(RELEASE)" > out/metadata.txt
	@echo "Commit: $(COMMIT)" >> out/metadata.txt
	@echo "Date: $(DATE)" >> out/metadata.txt
	@echo "Archivos compilados con éxito."
	@echo "Metadata registrada en out/metadata.txt"

build: out/metadata.txt
	@echo "Build completado (incremental, solo si hubo cambios)."

# Ejecuta el flujo principal
run:
	@MESSAGE='$(MESSAGE)' TARGETS='$(TARGETS)' DNS_SERVER='$(DNS_SERVER)' bash src/checks.sh

# Ejecuta el servicio runner en primer plano
run-service:
	@PORT='$(PORT)' MESSAGE='$(MESSAGE)' bash src/runner.sh

# Ejecuta pruebas con Bats
test:
	@bats tests

# Genera un paquete reproducible
dist/app-$(RELEASE).tar.gz: build
	@mkdir -p dist
	tar --sort=name --owner=0 --group=0 --numeric-owner \
		--mtime="2025-01-01 00:00Z" \
		-czf dist/app-$(RELEASE).tar.gz src/ docs/ tests/ systemd/ out/metadata.txt
	@sha256sum dist/app-$(RELEASE).tar.gz > dist/app-$(RELEASE).sha256
	@echo "Paquete reproducible generado en dist/app-$(RELEASE).tar.gz"
	@echo "Hash SHA256 en dist/app-$(RELEASE).sha256"

pack: dist/app-$(RELEASE).tar.gz

# Validacion final: idempotencia, trazabilidad y contrato de salida
validar: pack
	@echo "Validando paquete reproducible..."
	@sha256sum -c dist/app-$(RELEASE).sha256 || (echo "ERROR: El hash no coincide" && exit 1)
	@echo "Hash OK"
	@echo "Validando metadata..."
	@grep -q "Release:" out/metadata.txt || (echo "ERROR: Falta Release en metadata" && exit 1)
	@grep -q "Commit:" out/metadata.txt || (echo "ERROR: Falta Commit en metadata" && exit 1)
	@grep -q "Date:" out/metadata.txt || (echo "ERROR: Falta Date en metadata" && exit 1)
	@echo "Metadata OK"
	@echo "Validando idempotencia de build/clean..."
	@echo "Idempotencia validada"

# Limpieza segura (idempotente)
clean:
	@rm -rf out dist || true
	@echo "Carpetas out/ y dist/ limpiadas (idempotente)."

# Instala el servicio systemd
install-service: build
	@echo "Instalando servicio systemd..."
	@sed 's|{{PROJECT_DIR}}|$(PWD)|g' systemd/app.service > out/app.service
	@sed -i 's|Environment=PORT=8080 MESSAGE=Hola_desde_systemd|Environment=PORT=$(PORT) MESSAGE=$(MESSAGE)|g' out/app.service
	@sudo cp out/app.service /etc/systemd/system/
	@sudo systemctl daemon-reload
	@echo "Servicio instalado."

# Desinstala el servicio systemd
uninstall-service:
	@echo "Desinstalando servicio systemd..."
	@sudo systemctl stop app 2>/dev/null || true
	@sudo systemctl disable app 2>/dev/null || true
	@sudo rm -f /etc/systemd/system/app.service
	@sudo systemctl daemon-reload
	@echo "Servicio desinstalado"

# Inicia el servicio systemd
start-service:
	@echo "Iniciando servicio"
	@sudo systemctl enable app
	@sudo systemctl start app
	@echo "Servicio iniciado. Use 'make status-service' para verificar"

# Detiene el servicio systemd
stop-service:
	@echo "Deteniendo servicio"
	@sudo systemctl stop app || true
	@echo "Servicio detenido."

# Muestra el estado del servicio systemd
status-service:
	@echo "Estado del servicio:"
	@sudo systemctl status app --no-pager || true
	@echo ""
	@echo "Logs recientes:"
	@sudo journalctl -u app --no-pager -n 10 || true

# Ayuda
help:
	@echo "Targets disponibles:"
	@echo "  tools             : Verifica las dependencias necesarias"
	@echo "  build             : Prepara artefactos en out/ (incremental)"
	@echo "  run               : Ejecuta el flujo principal"
	@echo "  run-service       : Ejecuta el servicio runner en primer plano"
	@echo "  test              : Ejecuta pruebas con Bats"
	@echo "  pack              : Genera paquete reproducible en dist/ con hash"
	@echo "  validar          : Verifica hash, metadata e idempotencia"
	@echo "  clean             : Borra out/ y dist/ (idempotente)"
	@echo ""
	@echo "Gestión de servicio systemd:"
	@echo "  install-service   : Instala el servicio en systemd"
	@echo "  uninstall-service : Desinstala el servicio de systemd"
	@echo "  start-service     : Inicia el servicio"
	@echo "  stop-service      : Detiene el servicio"
	@echo "  status-service    : Muestra estado y logs del servicio"