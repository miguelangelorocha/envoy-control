#!/usr/bin/env bash

declare -a core_tests
declare -a tests

function map_tests() {
  for file in "$@"
  do
    class=$(echo "$file" | rev | cut -d '/' -f 1 | rev | cut -d '.' -f 1)
    echo -n "--tests *$class "
  done
}

for file in "$@"
do
    if [[ $file == *"envoy-control-core"* ]]; then
      core_tests+=($file)
    elif [[ $file == *"envoy-control-tests"* ]]; then
      tests+=($file)
    fi
done

core_tests_args=$(map_tests "${core_tests[@]}")
tests_args=$(map_tests "${tests[@]}")

if [[ -n "$core_tests_args" ]]; then
  echo "running core tests"
  ./gradlew :envoy-control-core:clean :envoy-control-core:test $core_tests_args
fi

if [[ -n "$tests_args" ]]; then
  echo "running tests"
  ./gradlew :envoy-control-tests:clean :envoy-control-tests:test $tests_args
fi
