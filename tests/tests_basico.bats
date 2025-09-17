#!/usr/bin/env bats

setup() {
  export MESSAGE="Hola desde mi app"
  export TARGETS="example.com"
  export DNS_SERVER="8.8.8.8"
  export PORT=9090
}

@test "Variable MESSAGE esta definida" {
  [ -n "$MESSAGE" ]
}

@test "Falla si falta variable de entorno" {
  unset MESSAGE
  run bash src/checks.sh
  [ "$status" -ne 0 ]
}

@test "Chequeo HTTP devuelve codigo 200" {
  run bash src/checks.sh
  [[ "$output" =~ "HTTP example.com -> 200" ]]
}

@test "runner.sh arranca y responde a SIGTERM" {
  bash src/runner.sh &
  pid=$!
  sleep 1
  kill -TERM "$pid"
  wait "$pid"
  [ $? -eq 0 ]
}

@test "Validar idempotencia de run" {
  run bash src/validar.sh
  [[ "$output" =~ "Idempotencia validada" ]]
}