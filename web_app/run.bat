@echo off
title PulmoScan AI
cd /d "%~dp0"

echo Checking Python...
py --version >nul 2>&1
if errorlevel 1 (
    echo Python not found.
    echo Install Python and enable "Add Python to PATH"
    pause
    exit /b
)

if not exist venv (
    echo Creating virtual environment...
    py -m venv venv
)

echo Activating virtual environment...
call venv\Scripts\activate

REM Install only once
if not exist venv\installed.flag (
    echo Installing dependencies...
    python -m pip install --upgrade pip
    pip install --default-timeout=1000 -r requirements.txt

    if errorlevel 1 (
        echo Installation failed.
        pause
        exit /b
    )

    echo done > venv\installed.flag
)

echo Starting backend...
python backend\app.py

echo.
echo Press any key to close...
pause