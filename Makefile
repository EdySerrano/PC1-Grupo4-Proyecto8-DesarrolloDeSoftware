# Variables
RELEASE ?= v0.1
DNS_SERVER ?= 8.8.8.8
TARGETS ?= ejemplo.com
MESSAGE ?= Hola desde mi app
PORT ?= 8080

# Targets
.PHONY: help tools build clean install-service start-service stop-service uninstall-service status-service

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

# Ejecuta el servicio runner en primer plano
run-service:
	@PORT='$(PORT)' MESSAGE='$(MESSAGE)' bash src/runner.sh

# Ejecuta pruebas con Bats
test:
	@bats tests

# Genera un paquete tar.gz en dist/
pack: build
	@mkdir -p dist
	tar -czf dist/app-$(RELEASE).tar.gz src/ docs/ tests/ systemd/
	@echo "Paquete generado en dist/app-$(RELEASE).tar.gz"

# Limpia las carpetas out
clean:
	@rm -rf out dist
	@echo "Carpetas out/ y dist/ limpiadas"

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
	@sudo systemctl stop app
	@echo "Servicio detenido."

# Muestra el estado del servicio systemd
status-service:
	@echo "Estado del servicio:"
	@sudo systemctl status app --no-pager || true
	@echo ""
	@echo "Logs recientes:"
	@sudo journalctl -u app --no-pager -n 10 || true

# Muestra los targets disponibles
help:
	@echo "Targets disponibles:"
	@echo "  tools			: Verifica las dependencias necesarias"
	@echo "  build			: Prepara los artefactos en out/"
	@echo "  run			: Ejecuta el flujo principal"
	@echo "  run-service	: Ejecuta el servicio runner en primer plano"
	@echo "  test			: Ejecuta pruebas con Bats"
	@echo "  pack			: Genera paquete reproducible en dist/"
	@echo "  clean			: Borra out/ y dist/"
	@echo ""
	@echo "Gestión de servicio systemd:"
	@echo "  install-service  : Instala el servicio en systemd"
	@echo "  uninstall-service: Desinstala el servicio de systemd"
	@echo "  start-service    : Inicia el servicio"
	@echo "  stop-service     : Detiene el servicio"
	@echo "  status-service   : Muestra estado y logs del servicio"
