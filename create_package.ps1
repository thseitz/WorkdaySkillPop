# Create distribution package for WorkdaySkillPop
$ErrorActionPreference = "Stop"

Write-Host "`n=== Creating WorkdaySkillPop Package ===`n" -ForegroundColor Cyan

# Define files to include
$filesToInclude = @(
    "skill_populator.py",
    "skills.txt",
    "requirements.txt",
    "install.ps1",
    "Install.bat",
    "README.md"
)

# Create temp directory
$tempDir = ".\WorkdaySkillPop"
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

# Copy files to temp directory
foreach ($file in $filesToInclude) {
    Copy-Item $file $tempDir
    Write-Host "✓ Copied $file" -ForegroundColor Green
}

# Create ZIP file
$zipPath = ".\WorkdaySkillPop.zip"
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Compress-Archive -Path "$tempDir\*" -DestinationPath $zipPath
Write-Host "✓ Created $zipPath" -ForegroundColor Green

# Cleanup
Remove-Item $tempDir -Recurse -Force
Write-Host "✓ Cleaned up temporary files" -ForegroundColor Green

Write-Host "`n=== Package Creation Complete! ===`n" -ForegroundColor Cyan
Write-Host "Package created at: $zipPath"
Write-Host "Ready for distribution!"
