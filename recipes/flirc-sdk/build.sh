#!/usr/bin/env bash

# pushd cli && CPPFLAGS="${CPPFLAGS} -Iinclude -Isrc -I../libs/" CFLAGS="${CFLAGS} -Wall -Werror" CCP=${CXX} LSEARCH=${PREFIX}/lib make flirc_util.release INSTALL=1 VERBOSE=1
# pushd flirc-sdk/cli && CCP=${CXX} LSEARCH=${PREFIX}/lib make --debug=all flirc_util INSTALL=1 VERBOSE=1

export CPPFLAGS="${CPPFLAGS} -Iinclude -Isrc -I../libs/"
export CFLAGS="${CFLAGS} -Wall -Werror"
export CCP=${CXX}
if [[ ${target_platform} == osx-64 ]]; then
  export LSEARCH="-L${PREFIX}/lib -L${PWD}/libs/Darwin_x86_64"
elif [[ ${target_platform} == linux-64 ]]; then
  export LSEARCH="-L${PREFIX}/lib -L${PWD}/libs/Linux_x86_64"
elif [[ ${target_platform} == win-32 ]]; then
  export LSEARCH="-L${PREFIX}/lib -L${PWD}/libs/Win"
fi
pushd cli
  make -f buildsystem/main.mk TARGETMK="targets/flirc_util.mk" DESTDIR=${PREFIX}/bin TARGET=flirc_util CONFIG=debug BUILDDIR=${PWD} install
popd
