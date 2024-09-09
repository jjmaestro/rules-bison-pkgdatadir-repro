#!/bin/bash
#
# Builds the librepro.a target in $BUILD_DIR using `cmake`
#
# Proves that repro/CMakeLists.txt is a valid `cmake` config file independently
# of the `cmake()` rule from `rules_foreign_cc` and `rules_bison`. Removes any
# existing $BUILD_DIR and performs the build fresh every time.

BISON="${BISON:-/opt/homebrew/opt/bison/bin/bison}"
export M4="${M4:-/opt/homebrew/opt/m4/bin/m4}"

if [[ ! -x "$BISON" || ! -x "$M4" ]]; then
  echo "Please set \$BISON and \$M4 to accessible values. Current values are:"
  echo "  BISON: ${BISON}"
  echo "  M4:    ${M4}"
  exit 1
fi

set -e

BUILD_DIR="./repro_cmake"
echo "Building ./repro in $BUILD_DIR using 'cmake' directly..."

if [[ -d "$BUILD_DIR" ]]; then
  rm -rf "$BUILD_DIR"
fi

mkdir "$BUILD_DIR"
cd "$BUILD_DIR"
cmake -DBISON_EXECUTABLE=$BISON ../repro
cmake --build .
