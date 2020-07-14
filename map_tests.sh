#!/usr/bin/env bash

function map_tests() {
  for file in "$@"
  do
    class=$(echo "$file" | rev | cut -d '/' -f 1 | rev | cut -d '.' -f 1)
    echo -n "--tests *$class "
  done
}

map_tests "$@"
