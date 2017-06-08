IF "%JAVA_HOME%" == "" GOTO NoJavaHome
JAVAC="%JAVA_HOME%"\bin\javac
JAR="%JAVA_HOME%"\bin\jar
goto DoneJavaHome
:NoJavaHome
JAVAC=javac
JAR=jar
:DoneJavaHome

if NOT EXIST %PREFIX%\Library\bin mkdir %PREFIX%\Library\bin

: This is deliberately compiled for the oldest version
: possible (in this case 1.5 since generics are used).
pushd src
  "%JAVAC%" -source 1.5 -target 1.5 JavaConfig.java
  echo Manifest-version: 1.0> manifest.mf
  echo Main-Class: JavaConfig>> manifest.mf
  "%JAR%" cfm java-config.jar manifest.mf JavaConfig.class
  copy java-config.jar %PREFIX%\Library\bin\
popd
copy "%RECIPE_DIR%"\java-config.bat %PREFIX%\Library\bin\
