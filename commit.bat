call pull.bat

@echo off

git add --all
git commit -m "Add product build"
git push

if not "%2" == "nopause" (
REM   pause
)