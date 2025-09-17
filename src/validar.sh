#!/usr/bin/env bash
set -euo pipefail

echo "Validando idempotencia..."
mkdir -p out
make run | sort > out/run1.log
make run | sort > out/run2.log

if diff out/run1.log out/run2.log > /dev/null; then
  echo "Idempotencia validada"
else
  echo "Diferencias encontradas en ejecuciones consecutivas"
  exit 1
fi

echo "Validando contrato de salida..."
if ls dist/app-*.tar.gz >/dev/null 2>&1; then
  echo "Paquete encontrado en dist/"
else
  echo "No se encontró paquete en dist/"
  exit 1
fi