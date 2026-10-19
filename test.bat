@echo off
setlocal
cd /d "%~dp0"
if not exist "backend\.venv\Scripts\python.exe" (
  where py >nul 2>nul
  if not errorlevel 1 (py -3 -m venv backend\.venv) else (python -m venv backend\.venv)
  if errorlevel 1 goto error
)
call backend\.venv\Scripts\python.exe -m pip install -r backend\requirements-dev.txt
if errorlevel 1 goto error
call backend\.venv\Scripts\python.exe -m compileall -q backend tests
if errorlevel 1 goto error
call backend\.venv\Scripts\python.exe -m pytest -q tests
if errorlevel 1 goto error
echo.
echo Unit test dan pemeriksaan sintaks selesai. Integrasi MySQL dijalankan hanya jika MYSQL_TEST_URL diatur.
pause
exit /b 0
:error
echo Pengujian gagal. Periksa log di atas.
pause
exit /b 1
