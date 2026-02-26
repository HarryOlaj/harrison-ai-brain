@echo off
setlocal
set REPO=C:\ai_ops\harrison-ai-brain
set LOG=%USERPROFILE%\.openclaw\logs\sync_guard.log
set PASS=1

echo [CHECK 1] Scheduled tasks
schtasks /Query /TN RepoSyncGuardOnLogon >nul 2>&1
if errorlevel 1 (
  echo FAIL: RepoSyncGuardOnLogon missing
  set PASS=0
) else (
  echo PASS: RepoSyncGuardOnLogon present
)

schtasks /Query /TN RepoSyncGuardEvery10m >nul 2>&1
if errorlevel 1 (
  echo FAIL: RepoSyncGuardEvery10m missing
  set PASS=0
) else (
  echo PASS: RepoSyncGuardEvery10m present
)

echo.
echo [CHECK 2] Sync guard log
if not exist "%LOG%" (
  echo FAIL: sync_guard.log missing
  set PASS=0
) else (
  for /f "delims=" %%L in ('powershell -NoProfile -Command "(Get-Content $env:USERPROFILE\\.openclaw\\logs\\sync_guard.log | Select-Object -Last 1)"') do set LAST=%%L
  echo LAST_LOG: %LAST%
  echo %LAST% | findstr /I /C:"HEAD:" >nul || set PASS=0
  echo %LAST% | findstr /I /C:"CLEAN:" >nul || set PASS=0
  echo %LAST% | findstr /I /C:"WORKSPACE:%REPO%" >nul || set PASS=0
)

echo.
echo [CHECK 3] Git state
cd /d %REPO% >nul 2>&1
if errorlevel 1 (
  echo FAIL: repo path missing %REPO%
  set PASS=0
) else (
  for /f %%i in ('git rev-parse --short HEAD') do set HEAD=%%i
  git status --short > %TEMP%\verify_sync_status.txt
  for %%A in (%TEMP%\verify_sync_status.txt) do set SIZE=%%~zA
  if "%SIZE%"=="0" (set CLEAN=yes) else (set CLEAN=no)
  echo HEAD:%HEAD% CLEAN:%CLEAN% WORKSPACE:%REPO%
)

echo.
if "%PASS%"=="1" (
  echo RESULT: PASS
  exit /b 0
) else (
  echo RESULT: FAIL
  exit /b 1
)
