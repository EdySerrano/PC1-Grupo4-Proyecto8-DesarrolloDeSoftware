#!/usr/bin/env bash
set -euo pipefail

# Manejo de errores
trap 'echo "Error en la ejecucion (linea $LINENO)"; exit 1' ERR
trap 'echo "Saliendo, limpieza finalizada"' EXIT

# Variables de entorno
: "${MESSAGE:?Variable MESSAGE no definida}"
: "${TARGETS:?Variable TARGETS no definida}"
: "${DNS_SERVER:?Variable DNS_SERVER no definida}"

http_check(){
  local host=$1
  curl -s -o /dev/null -w "%{http_code}" "http://$host"
}

dns_check(){
  local host=$1
  # solo direcciones IPv4 validas
  dig @"$DNS_SERVER" +short "$host" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' || true
}

echo "Se esta ejecutando chequeos con mensaje: $MESSAGE"

for host in $TARGETS; do
  code=$(http_check "$host")
  # solo mostrar host y codigo
  echo "HTTP $host -> $code"

  result=$(dns_check "$host")
  echo "DNS $host -> ${result:-No encontrado}"
done
