@echo off
if "%TOMCAT_HOME%"=="" (echo Please set TOMCAT_HOME to your apache-tomcat-9.0.122 folder.&pause&exit /b 1)
if not exist "%TOMCAT_HOME%\lib\servlet-api.jar" (echo servlet-api.jar not found in %TOMCAT_HOME%\lib&pause&exit /b 1)
if not exist "WEB-INF\classes" mkdir "WEB-INF\classes"
javac -encoding UTF-8 -cp "%TOMCAT_HOME%\lib\servlet-api.jar" -d "WEB-INF\classes" src\java\com\hospital\*.java
if errorlevel 1 (echo Compilation failed.&pause&exit /b 1)
echo Compilation successful.
pause
