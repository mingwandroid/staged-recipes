#!/bin/bash

declare -a CMAKE_EXTRA_ARGS
if [[ ${target_platform} =~ linux-* ]]; then
  echo "Nothing special for linux"
elif [[ ${target_platform} == osx-64 ]]; then
  CMAKE_EXTRA_ARGS+=(-DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT})
fi

mkdir build
cd build

if [[ ! -f Makefile ]]; then

  cmake .. -LAH                                                             \
    -DCMAKE_BUILD_TYPE="Release"                                            \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}"                                      \
    -DCMAKE_INSTALL_LIBDIR=lib                                              \
    -DCMAKE_SKIP_RPATH=ON                                                   \
    -DCMAKE_AR="${AR}"                                                      \
    -DCMAKE_LINKER="${LD}"                                                  \
    -DCMAKE_NM="${NM}"                                                      \
    -DCMAKE_OBJCOPY="${OBJCOPY}"                                            \
    -DCMAKE_OBJDUMP="${OBJDUMP}"                                            \
    -DCMAKE_RANLIB="${RANLIB}"                                              \
    -DCMAKE_STRIP="${STRIP}"                                                \
    -DLIEF_PYTHON_API=OFF                                                   \
    "${CMAKE_EXTRA_ARGS[@]}"

  if [[ ! $? ]]; then
    echo "configure failed with $?"
    exit 1
  fi
fi

make -j${CPU_COUNT} ${VERBOSE_CM}

rm -rf "${PREFIX}"/share/LIEF/examples/
