IF "%JAVA_HOME%" == "" GOTO NoJavaHome
"%JAVA_HOME%"\bin\java -jar "%~dp0"java-config.jar %*
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
exit /b 0

:NoJavaHome
java -jar "%dp0"java-config.jar %*
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
exit /b 0
