SKIP_XCODEBUILD=yes  \
  bash -x ./fetchDependencies -v
export SDKROOT=${CONDA_BUILD_SYSROOT}
cmake -DCMAKE_CXX=${CXX}  \
      -DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT}  \
      --debug-trycompile -Wdev --debug-output --trace  \
      ExternalDependencies.CMakeList.txt | tee ExternalDependencies.config.log
make -j${CPU_COUNT} all | tee ExternalDependencies.make.log
pushd MoltenVK
  cmake -DCMAKE_CXX=${CXX}  \
        -DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT}  \
        --debug-trycompile -Wdev --debug-output --trace  \
        . | tee MoltenVK.config.log
  make -j${CPU_COUNT} | tee MoltenVK.make.log
popd
# make macos
# cmake .
# ninja release
