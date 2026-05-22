@echo off
title PulmoScan AI
cd /d "%~dp0"

echo Checking Python...
py --version >nul 2>&1
if errorlevel 1 (
    echo Python not found. Install Python and enable "Add Python to PATH"
    pause
    exit /b
)

if not exist venv (
    echo Creating virtual environment...
    py -m venv venv
)

echo Activating virtual environment...
call venv\Scripts\activate

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

echo Checking models...
if not exist ..\models\lung_cancer_classifier.keras (
    echo Reassembling classification model...
    python -c "
import os
def join_parts(parts_folder, output_path):
    parts = sorted(os.listdir(parts_folder))
    with open(output_path, 'wb') as out:
        for part in parts:
            with open(os.path.join(parts_folder, part), 'rb') as f:
                out.write(f.read())
    print('Done: ' + output_path)
join_parts(r'..\models\lung_cancer_classifier.keras_parts', r'..\models\lung_cancer_classifier.keras')
"
)

if not exist ..\models\lung_segmentation_model.keras (
    echo Reassembling segmentation model...
    python -c "
import os
def join_parts(parts_folder, output_path):
    parts = sorted(os.listdir(parts_folder))
    with open(output_path, 'wb') as out:
        for part in parts:
            with open(os.path.join(parts_folder, part), 'rb') as f:
                out.write(f.read())
    print('Done: ' + output_path)
join_parts(r'..\models\lung_segmentation_model.keras_parts', r'..\models\lung_segmentation_model.keras')
"
)

echo Starting backend...
python backend\app.py
pause
