Write-Host "Checking and installing required packages..."
pip install -r "C:\Users\bob\CascadeProjects\WorkdaySkillPop\requirements.txt"

# Check if Chrome is running in debug mode
$debugPort = 9222
$testConnection = $null
try {
    $testConnection = New-Object System.Net.Sockets.TcpClient("localhost", $debugPort)
} catch {}

if (-not $testConnection) {
    Write-Host "`nERROR: Chrome is not running in debug mode!" -ForegroundColor Red
    Write-Host "Please follow these steps:" -ForegroundColor Yellow
    Write-Host "1. Double-click the 'Chrome Debug Mode' shortcut on your desktop" -ForegroundColor Yellow
    Write-Host "2. Navigate to your Workday application page" -ForegroundColor Yellow
    Write-Host "3. Run this script again when you're on the skills page" -ForegroundColor Yellow
    Write-Host "`nPress Enter to exit..."
    $null = Read-Host
    exit 1
}

if ($testConnection) {
    $testConnection.Close()
}

Write-Host "`nChrome debug mode detected!" -ForegroundColor Green
Write-Host "Make sure you are on the correct Workday page with the skills widget visible."
Write-Host "Press Enter when ready..."
$null = Read-Host
python "C:\Users\bob\CascadeProjects\WorkdaySkillPop\skill_populator.py"
Write-Host "`nPress Enter to close this window..."
$null = Read-Host
