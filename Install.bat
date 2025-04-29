@echo off
echo === WorkdaySkillPop Installer ===

:: Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo Python is not installed!
    echo Please install Python 3.8 or later from https://www.python.org/downloads/
    echo Make sure to check 'Add Python to PATH' during installation
    pause
    exit /b 1
)

:: Check pip
pip --version >nul 2>&1
if errorlevel 1 (
    echo pip is not installed!
    echo Please ensure pip is installed with Python
    pause
    exit /b 1
)

:: Install requirements
echo Installing Python dependencies...
pip install -r requirements.txt
if errorlevel 1 (
    echo Failed to install dependencies
    pause
    exit /b 1
)

:: Create Chrome Debug Mode shortcut
echo Set WshShell = CreateObject("WScript.Shell") > "%TEMP%\shortcut.vbs"
echo Set Shortcut = WshShell.CreateShortcut("%USERPROFILE%\Desktop\Chrome Debug Mode.lnk") >> "%TEMP%\shortcut.vbs"
echo Shortcut.TargetPath = "%ProgramFiles%\Google\Chrome\Application\chrome.exe" >> "%TEMP%\shortcut.vbs"
echo Shortcut.Arguments = "--remote-debugging-port=9222 --user-data-dir=""%USERPROFILE%\chrome-debug""" >> "%TEMP%\shortcut.vbs"
echo Shortcut.Save >> "%TEMP%\shortcut.vbs"
cscript //nologo "%TEMP%\shortcut.vbs"
del "%TEMP%\shortcut.vbs"

:: Create Run Skill Populator shortcut
echo Set WshShell = CreateObject("WScript.Shell") > "%TEMP%\shortcut.vbs"
echo Set Shortcut = WshShell.CreateShortcut("%USERPROFILE%\Desktop\Run Skill Populator.lnk") >> "%TEMP%\shortcut.vbs"
echo Shortcut.TargetPath = "python.exe" >> "%TEMP%\shortcut.vbs"
echo Shortcut.Arguments = "%~dp0skill_populator.py" >> "%TEMP%\shortcut.vbs"
echo Shortcut.WorkingDirectory = "%~dp0" >> "%TEMP%\shortcut.vbs"
echo Shortcut.Save >> "%TEMP%\shortcut.vbs"
cscript //nologo "%TEMP%\shortcut.vbs"
del "%TEMP%\shortcut.vbs"

echo.
echo === Installation Complete! ===
echo.
echo To use WorkdaySkillPop:
echo 1. Double-click 'Chrome Debug Mode' shortcut on your desktop
echo 2. Navigate to the Workday skills page
echo 3. Double-click 'Run Skill Populator' shortcut
echo.
echo For more information, please read the README.md file
pause
