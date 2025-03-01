@echo off
set ENV_NAME=myenv
set REQUIREMENTS=requirements.txt

:: Delete old environment if it exists
if exist %ENV_NAME% (
    echo Deleting old environment...
    rmdir /s /q %ENV_NAME%
)

:: Create new environment
echo Creating new environment...
python -m venv %ENV_NAME%

:: Activate the environment
call %ENV_NAME%\Scripts\activate.bat

:: Upgrade pip and install requirements
python -m pip install --upgrade pip
pip install -r %REQUIREMENTS%

echo Environment setup complete!
cmd /k "%ENV_NAME%\Scripts\activate.bat"
