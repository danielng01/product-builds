@echo off

ECHO Important! Close Iris mini before using hidden features
ECHO -----
ECHO Set Iris mini Color temperature to:
set color_temperature=3400
set /p color_temperature=Enter number between 1200 and 20000 (default is 3400K) - 

REG ADD HKCU\Software\IrisTech\IrisMini /v Temperature /t REG_DWORD /d %color_temperature% /f