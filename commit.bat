SETLOCAL

SET commit_bat_path=%~dp0
echo %commit_bat_path:~0,-1%
CD /D %commit_bat_path%

call pull.bat

@echo off

git add --all
git commit -m "Add product build"
git push

if not "%2" == "nopause" (
REM   pause
)

ENDLOCAL