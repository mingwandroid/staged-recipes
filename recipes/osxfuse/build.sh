#!/usr/bin/env bash

export CPPFLAGS="-DPR_SET_NO_NEW_PRIVS=38 -DPR_GET_NO_NEW_PRIVS=39 -DOSXFUSE_VERSION=\\\"${PKG_VERSION}\\\" ${CPPFLAGS}"
autopoint -f
autoreconf -vfi -I${PREFIX}/share/aclocal

mkdir build || true
  pushd build || exit 1
    ../configure \
      --prefix="${PREFIX}" \
      --libdir="${PREFIX}"/lib \
      --sbindir="${PREFIX}"/bin \
      MOUNT_FUSE_PATH="${PREFIX}"/bin \
      UDEV_RULES_PATH="${PREFIX}"/etc/udev/rules.d
  make -j${CPU_COUNT} ${VERBOSE_AT}
  make install
popd
