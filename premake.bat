@echo off
cd /D "%~dp0"

"ispc-premake/premake5.exe" --file=premake.lua vs2019

pause
