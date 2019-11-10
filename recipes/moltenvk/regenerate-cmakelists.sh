$!/usr/bin/env bash

declare -a XC_TO_CM=()
XC_TO_CM+=('${HOME}/brew/Cellar/mulle-xcode-to-cmake/0.9.0/bin/mulle-xcode-to-cmake')
XC_TO_CM+=('-2')
XC_TO_CM+=('-d')

"${XC_TO_CM[@]}" export ExternalDependencies.xcodeproj > ExternalDependencies.CMakeList.txt
sed -i.bak 's|CMakeSourcesAndHeaders.txt|ExternalDependencies.CMakeSourcesAndHeaders.txt|g' ExternalDependencies.CMakeList.txt
rm ExternalDependencies.CMakeList.txt.bak
"${XC_TO_CM[@]}" sexport ExternalDependencies.xcodeproj > ExternalDependencies.CMakeSourcesAndHeaders.txt

"${XC_TO_CM[@]}" export MoltenVKPackaging.xcodeproj > MoltenVKPackaging.CMakeList.txt
sed -i.bak 's|CMakeSourcesAndHeaders.txt|MoltenVKPackaging.CMakeSourcesAndHeaders.txt|g' MoltenVKPackaging.CMakeList.txt
rm MoltenVKPackaging.CMakeList.txt.bak
"${XC_TO_CM[@]}" sexport MoltenVKPackaging.xcodeproj > MoltenVKPackaging.CMakeSourcesAndHeaders.txt

PROJSUBDIRS=()
while IFS=  read -r -d $'\0'; do
    PROJSUBDIRS+=("$REPLY")
done < <(find . -mindepth 2 -name "*.xcodeproj" -print0)

for PROJSUBDIR in "${PROJSUBDIRS[@]}"; do
  echo $PROJSUBDIR
  pushd $(dirname "${PROJSUBDIR}")
    BASENAME=$(basename "${PROJSUBDIR}")
    echo ${BASENAME}
    "${XC_TO_CM[@]}" export ${BASENAME} > CMakeLists.txt
    "${XC_TO_CM[@]}" sexport ${BASENAME} > CMakeSourcesAndHeaders.txt
  popd
done
