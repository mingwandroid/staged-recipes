#!/usr/bin/env bash

set -ex

mkdir build
pushd build

if [[ ${target_platform} == linux.* ]]; then
  export LDFLAGS="${LDFLAGS} -lrt"
fi
cmake \
  -GNinja \
  -DVULKAN_HEADERS_INSTALL_DIR=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_LINKER_FLAGS="${LDFLAGS}" \
  -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
  -DCMAKE_C_FLAGS="${CFLAGS}" \
  ..
cmake --build . --target install -v

popd
