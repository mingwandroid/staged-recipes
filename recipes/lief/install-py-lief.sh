#!/bin/bash

# We install two local pythons so that we can build everything at once.
# The 2nd Python 3 variant does of course cause us problems that we hack
# around in install-py-opencv.sh, still better than building all of libopencv
# 6 times instead of twice (3 * python, 2 * hdf5).
# conda create -yp ${PWD}/py2 --override-channels -c https://repo.continuum.io/pkgs/main python=2.7 numpy=1.9
# conda create -yp ${PWD}/py3 --override-channels -c https://repo.continuum.io/pkgs/main python=3.6 numpy=1.9

declare -a CMAKE_EXTRA_ARGS
if [[ ${target_platform} =~ linux-* ]]; then
  echo "Nothing special for linux"
elif [[ ${target_platform} == osx-64 ]]; then
  CMAKE_EXTRA_ARGS+=(-DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT})
else
  echo "target_platform not known: ${target_platform}"
  exit 1
fi

mkdir build || true
# -${PY_VER} || true
pushd build
# -${PY_VER}

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
    -DLIEF_PYTHON_API=ON                                                    \
    -DLIEF_INSTALL_PYTHON=ON                                                \
    -DPYTHON_INCLUDE_DIR:PATH=$(${PYTHON} -c 'from sysconfig import get_paths; print(get_paths()["include"])')  \
    -DPYTHON_LIBRARY="${PREFIX}"/lib/libpython${PY_VER}.dylib               \
    -DPYTHON_LIBRARY_DEBUG="${PREFIX}"/lib/libpython${PY_VER}.dylib         \
    -DPYTHON_VERSION=${PY_VER}                                              \
    "${CMAKE_EXTRA_ARGS[@]}"


    #-DPYTHON_LIBRARY:FILEPATH=                                              \
    #-DPYTHON_LIBRARY_DEBUG:FILEPATH=                                        \


  if [[ ! $? ]]; then
    echo "configure failed with $?"
    exit 1
  fi

set -x
make -j${CPU_COUNT} ${VERBOSE_CM}
make install ${VERBOSE_CM}
echo LIZZY after make install
find ${SP_DIR}
pushd api/python
#  cp _pylief.so ${SP_DIR}
#  echo LIZZY after cp
  find ${SP_DIR}
  ${PYTHON} setup.py install --single-version-externally-managed --record=record.txt
  echo LIZZY after setup.py
  find ${SP_DIR}
  ${INSTALL_NAME_TOOL:-install_name_tool} -id @rpath/_pylief.cpython-${CONDA_PY}m-darwin.so ${SP_DIR}/_pylief.cpython-${CONDA_PY}m-darwin.so
popd
popd

