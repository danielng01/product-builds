@echo off

ECHO Important! Close Iris mini before using hidden features
ECHO -----
ECHO Set Iris mini Brightness to:
set brightness=80
set /p brightness=Enter number between 20 and 100 (default is 80%) - 

REG ADD HKCU\Software\IrisTech\IrisMini /v Brightness /t REG_DWORD /d %brightness% /f