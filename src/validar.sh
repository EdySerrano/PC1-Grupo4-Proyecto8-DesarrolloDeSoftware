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