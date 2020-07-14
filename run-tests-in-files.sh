#!/usr/bin/env bash

modules=$(cat settings.gradle | grep include | cut -d " " -f 2 | cut -d "'" -f 2)

exit_code=0

for module in $modules
do
  tests_to_run=()
  for file in "$@"
  do
      if [[ $file == *"$module"* ]]; then
        tests_to_run+=($file)
      fi
  done

  if [[ -n "$tests_to_run" ]]; then
    echo "running $module tests"
    mapped_tests=$(./map_tests.sh "${tests_to_run[@]}")

    # not using clean since on CI it should be ok
    #        ▽ :"$module":clean
    ./gradlew --offline :"$module":test $mapped_tests

    if [ $? -ne 0 ]; then
      exit_code=1
    fi
  fi
done

exit $exit_code
