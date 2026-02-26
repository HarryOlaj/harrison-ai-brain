@echo off
setlocal
set REPO=C:\ai_ops\harrison-ai-brain
set LOG=%USERPROFILE%\.openclaw\logs\sync_guard.log
if not exist %USERPROFILE%\.openclaw\logs mkdir %USERPROFILE%\.openclaw\logs

cd /d %REPO% || exit /b 1

git fetch origin >nul 2>&1
git checkout main >nul 2>&1
git reset --hard origin/main >nul 2>&1

for /f %%i in ('git rev-parse --short HEAD') do set HEAD=%%i
git status --short > %TEMP%\sync_guard_status.txt
for %%A in (%TEMP%\sync_guard_status.txt) do set SIZE=%%~zA
if "%SIZE%"=="0" (set CLEAN=yes) else (set CLEAN=no)

echo [%date% %time%] HEAD:%HEAD% CLEAN:%CLEAN% WORKSPACE:%REPO%>> %LOG%
endlocal
exit /b 0
