# WorkdaySkillPop Installer
$ErrorActionPreference = "Stop"

Write-Host "`n=== WorkdaySkillPop Installer ===`n" -ForegroundColor Cyan

# Check if Python is installed
try {
    $pythonVersion = python --version
    Write-Host "✓ Found Python: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Python is not installed!" -ForegroundColor Red
    Write-Host "Please install Python 3.8 or later from https://www.python.org/downloads/"
    Write-Host "Make sure to check 'Add Python to PATH' during installation"
    exit 1
}

# Check if pip is installed
try {
    $pipVersion = pip --version
    Write-Host "✓ Found pip: $pipVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ pip is not installed!" -ForegroundColor Red
    Write-Host "Please ensure pip is installed with Python"
    exit 1
}

# Install requirements
Write-Host "`nInstalling Python dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Dependencies installed successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

# Create Chrome Debug Mode shortcut
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Chrome Debug Mode.lnk")
$Shortcut.TargetPath = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
$Shortcut.Arguments = "--remote-debugging-port=9222 --user-data-dir=`"$Home\chrome-debug`""
$Shortcut.Save()
Write-Host "✓ Created Chrome Debug Mode shortcut on desktop" -ForegroundColor Green

# Create Run Skill Populator shortcut
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Run Skill Populator.lnk")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-NoExit -Command `"& python '$PWD\skill_populator.py'`""
$Shortcut.WorkingDirectory = $PWD
$Shortcut.Save()
Write-Host "✓ Created Run Skill Populator shortcut on desktop" -ForegroundColor Green

Write-Host "`n=== Installation Complete! ===`n" -ForegroundColor Cyan
Write-Host "To use WorkdaySkillPop:"
Write-Host "1. Double-click 'Chrome Debug Mode' shortcut on your desktop"
Write-Host "2. Navigate to the Workday skills page"
Write-Host "3. Double-click 'Run Skill Populator' shortcut"
Write-Host "`nFor more information, please read the README.md file"
