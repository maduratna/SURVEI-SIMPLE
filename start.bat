@echo off
setlocal
cd /d "%~dp0"
echo =============================================
echo SIMPLE-SURVEI - Local Development Launcher
echo =============================================
if not exist "backend\.env" (
  copy "backend\.env.example" "backend\.env" >nul
  echo File backend\.env dibuat. Silakan sesuaikan MYSQL_URL dan JWT_SECRET.
  echo Setelah konfigurasi selesai, jalankan start.bat lagi.
  pause
  exit /b 1
)
if not exist "backend\.venv\Scripts\python.exe" (
  echo Membuat virtual environment backend...
  where py >nul 2>nul
  if not errorlevel 1 (
    py -3 -m venv backend\.venv
  ) else (
    python -m venv backend\.venv
  )
  if errorlevel 1 goto error
)
if not exist "backend\.deps-installed" (
  echo Memasang dependensi backend (memerlukan internet pada instalasi pertama)...
  call backend\.venv\Scripts\python.exe -m pip install -r backend\requirements.txt
  if errorlevel 1 goto error
  echo installed>backend\.deps-installed
)
if not exist "frontend\node_modules" (
  echo Memasang dependensi frontend...
  pushd frontend
  call npm install
  if errorlevel 1 (popd & goto error)
  popd
)
echo Jalankan MySQL Server terlebih dahulu dan pastikan database simple_survei sudah dibuat.
start "SIMPLE-SURVEI Backend" cmd /k "cd /d ""%~dp0backend"" ^&^& .venv\Scripts\python.exe -m uvicorn server:app --reload --host 127.0.0.1 --port 8000"
start "SIMPLE-SURVEI Frontend" cmd /k "cd /d ""%~dp0frontend"" ^&^& npm start"
echo Browser biasanya tersedia di http://localhost:3000
exit /b 0
:error
echo Terjadi kesalahan. Periksa pesan di atas dan README.md.
pause
exit /b 1
