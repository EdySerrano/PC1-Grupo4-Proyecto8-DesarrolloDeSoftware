#!/usr/bin/env bats

setup() {
  export MESSAGE="Hola desde mi app"
  export TARGETS="ejemplo.com"
  export DNS_SERVER="8.8.8.8"
  export PORT = 9090
}

@test "Variable MESSAGE esta definida" {
  [ -n "$MESSAGE" ]
}

@test "Falla si falta variable de entorno" {
  unset MESSAGE
  run bash src/checks.sh
  [ "$status" -ne 0 ]
}

@test "Chequeo HTTP devuelve código 200" {
  run bash src/checks.sh
  [[ "$output" =~ "HTTP example.com -> 200" ]]
}