pushd build
  cmake --build . --target INSTALL --config Release
  if errorlevel 1 exit /b 1
popd
