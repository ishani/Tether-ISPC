@echo off
cd /D "%~dp0"

"premake-bin/premake5.exe" --file=premake.lua vs2022

pause
