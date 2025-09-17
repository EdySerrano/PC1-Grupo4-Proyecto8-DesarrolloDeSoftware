#!/usr/bin/env bash
set -euo pipefail

: "${PORT:?Variable PORT no definida}"

trap 'echo "Proceso detenido con SIGINT"; exit 0' SIGINT
trap 'echo "Proceso detenido con SIGTERM"; exit 0' SIGTERM

echo "Ejecutando servicio en el puerto $PORT..."
while true; do
  echo "Servicio escuchando en el puerto $PORT"
  sleep 5
done
