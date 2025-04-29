@echo off
echo Creating WorkdaySkillPop Package...

:: Create temp directory
if exist WorkdaySkillPop rmdir /s /q WorkdaySkillPop
mkdir WorkdaySkillPop

:: Copy files
copy skill_populator.py WorkdaySkillPop\
copy skills.txt WorkdaySkillPop\
copy requirements.txt WorkdaySkillPop\
copy install.ps1 WorkdaySkillPop\
copy Install.bat WorkdaySkillPop\
copy README.md WorkdaySkillPop\

:: Create ZIP file
if exist WorkdaySkillPop.zip del WorkdaySkillPop.zip
powershell Compress-Archive -Path WorkdaySkillPop\* -DestinationPath WorkdaySkillPop.zip

:: Cleanup
rmdir /s /q WorkdaySkillPop

echo Package created successfully!
echo File: WorkdaySkillPop.zip
pause
