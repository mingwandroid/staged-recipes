#!/bin/bash

if [ -n "$JAVA_HOME" ]; then
  JAVAC="${JAVA_HOME}"/bin/java
  JAR="${JAVA_HOME}"/bin/jar
else
  JAVAC=javac
  JAR=jar
fi

# This is deliberately compiled for the oldest version
# possible (in this case 1.5 since generics are used).
pushd src
  git rev-parse HEAD > build.txt
  ${JAVAC} -source 1.5 -target 1.5 JavaConfig.java
  echo "Manifest-version: 1.0"   > manifest.mf
  echo "Main-Class: JavaConfig" >> manifest.mf
  echo ""                       >> manifest.mf
  echo "Name: usage.txt"        >> manifest.mf
  echo ""                       >> manifest.mf
  echo "Name: build.txt"        >> manifest.mf
  ${JAR} cfm java-config.jar manifest.mf JavaConfig.class
  cp java-config.jar ${PREFIX}/bin
popd
cp "${RECIPE_DIR}"/java-config.sh ${PREFIX}/bin
chmod +x ${PREFIX}/bin/java-config.sh
exit 1
