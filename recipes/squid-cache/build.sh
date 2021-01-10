#!/usr/bin/env bash

set -e

# Yes, this is all pretty ugly, but in general you must use an exact build of cppunit when
# testing something against it. Also, we've already done the make install by the time we do
# the make check so nothing from cppunit can possibly make it into the prefix.
pushd cppunit > /dev/null 2>&1 || exit 1
  autoreconf -vfi
  mkdir build || true
  pushd build /dev/null 2>&1 || exit 1
    ../configure  \
      --prefix=${BUILD_PREFIX}
    make -j${CPU_COUNT}
    make install
  popd > /dev/null 2>&1 || exit 1
popd > /dev/null 2>&1 || exit 1

pushd squid-cache > /dev/null 2>&1 || exit 1
  autoreconf -vfi
  mkdir build || true
  pushd build /dev/null 2>&1 || exit 1
    ../configure  \
      --prefix=${PREFIX}  \
      --datarootdir=${PREFIX}/share/squid-cache
    make -j${CPU_COUNT}
    make install
    set +e
    # || true because even when there are no failures, we get an error. We need to check the text for "FAIL:  N" where N isn't 0
    # instead. That TODO.
    CPPFLAGS="${CPPFLAGS} -I${BUILD_PREFIX}/include -DHAVE_CPPUNIT_EXTENSIONS_HELPERMACROS_H"  \
    CFLAGS="${CFLAGS} -I${BUILD_PREFIX}/include"  \
    CXXFLAGS="${CXXFLAGS} -I${BUILD_PREFIX}/include"  \
    LDFLAGS="-L${BUILD_PREFIX}/lib -lcppunit"  \
      make check -j${CPU_COUNT} CPPFLAGS="${CPPFLAGS} -I${BUILD_PREFIX}/include -DHAVE_CPPUNIT_EXTENSIONS_HELPERMACROS_H"  \
                                CFLAGS="${CFLAGS} -I${BUILD_PREFIX}/include"  \
                                CXXFLAGS="${CXXFLAGS} -I${BUILD_PREFIX}/include"  \
                                LDFLAGS="-L${BUILD_PREFIX}/lib -lcppunit" || true
    set -e
  popd > /dev/null 2>&1 || exit 1
popd > /dev/null 2>&1 || exit 1

exit 0
