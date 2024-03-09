@echo off
REG QUERY HKCU\Software\ITAUL\Iris /v activation_code

FOR /F "tokens=3" %%x IN ('REG QUERY HKCU\Software\ITAUL\Iris /v activation_code') DO set "QUERY_RESULT=%%x"

if [%QUERY_RESULT%]==[] set QUERY_RESULT=NOT_SET

ECHO Iris activation code before v1.2.0 is: %QUERY_RESULT%
Msg * "Iris activation code before v1.2.0 is: %QUERY_RESULT%"

for /f "tokens=*" %%f in ('find "ActivationCode=" "C:\Users\danielng01\Desktop\test me\iris_settings.ini"') do set ACTIVATION_CODE=%%f

echo Iris after 1.2.0 - %ACTIVATION_CODE%
Msg * "Iris after 1.2.0 - %ACTIVATION_CODE%"

PAUSE