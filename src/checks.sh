#!/usr/bin/env bash
set -euo pipefail

# Manejo de errores
trap 'echo "Error en la ejecucion (linea $LINENO)"; exit 1' ERR
trap 'echo "Saliendo, limpieza finalizada"' EXIT

# Variables de entorno
: "${MESSAGE:?Variable MESSAGE no definida}"
: "${TARGETS:?Variable TARGETS no definida}"
: "${DNS_SERVER:?Variable DNS_SERVER no definida}"

echo "Se esta ejecutando chequeos con mensaje: $MESSAGE"

# Chequeo de HTTP
for host in $TARGETS; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "http://$host")
  echo "HTTP $host -> $code"
done

# Chequeo de DNS
for host in $TARGETS; do
  result=$(dig @"$DNS_SERVER" +short "$host")
  echo "DNS $host -> $result"
done
