bash -x ./fetchDependencies -v
pushd MoltenVK
  cmake -DCMAKE_CXX=${CXX} .
  make -j${CPU_COUNT}
popd
# make macos
# cmake .
# ninja release
