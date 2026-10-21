@echo off
cd /d "%~dp0"
if not exist "POP.EXE.bak" (
 echo ERROR: POP.EXE.bak not found.
 pause
 exit /b 1
)
copy /y "POP.EXE.bak" "POP.EXE" >nul
echo Original POP.EXE restored from POP.EXE.bak.
pause
