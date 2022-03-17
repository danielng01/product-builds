@echo off
REG QUERY HKCU\Software\ITAUL\Iris /v activation_code

FOR /F "tokens=3" %%x IN ('REG QUERY HKCU\Software\ITAUL\Iris /v activation_code') DO set "QUERY_RESULT=%%x"

if [%QUERY_RESULT%]==[] set QUERY_RESULT=NOT_SET

ECHO Iris activation code is: %QUERY_RESULT%
Msg * "Iris activation code is: %QUERY_RESULT%"
PAUSE