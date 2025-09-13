#!/usr/bin/env bats

setup() {
  export MESSAGE="Hello"
  export TARGETS="example.com"
  export DNS_SERVER="8.8.8.8"
}

@test "Variable MESSAGE está definida" {
  [ -n "$MESSAGE" ]
}

@test "Chequeo HTTP devuelve código 200" {
  run bash src/checks.sh
  [[ "$output" =~ "HTTP example.com -> 200" ]]
}