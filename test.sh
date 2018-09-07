#!/bin/bash

function testVariant() {
  echo "testing $1 variant of hook"
  HOOK_VARIANT=$1 ./bats-core/bin/bats spec.bats
}

if [[ -n "$1" ]]; then
  testVariant $1
else
  testVariant js
  testVariant shell
fi
