#!/usr/bin/env bash
set -euo pipefail

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
