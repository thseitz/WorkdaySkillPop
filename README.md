# WorkdaySkillPop

A Python automation tool that helps populate skills in Workday job applications using Selenium WebDriver.

## Quick Start (Windows)

1. Download and extract the WorkdaySkillPop.zip file
2. Double-click `Install.bat`
3. Follow the on-screen instructions

## Prerequisites

- Windows 10 or later
- Python 3.8 or later (will be checked by installer)
- Google Chrome browser
- Internet connection for downloading dependencies

## Manual Installation

If you prefer to install manually:

1. Install Python from https://www.python.org/downloads/
   - Make sure to check "Add Python to PATH" during installation

2. Install Python requirements:
```bash
pip install -r requirements.txt
```

3. Edit `skills.txt` and add your skills (one per line)

## Usage

1. Start Chrome in debug mode using one of these methods:

   A. Using the Desktop Shortcut (Recommended):
   - Double-click the "Chrome Debug Mode" shortcut on your desktop

   B. Manual command:
   ```powershell
   start chrome.exe --remote-debugging-port=9222 --user-data-dir="C:\chrome-debug"
   ```

2. In Chrome:
   - Navigate to Workday
   - Log in and go through the application process
   - Stop when you reach the page with the Skills widget
   - Click on the widget so that it is highlighted

3. Run the skill populator:
   - Double-click the "Run Skill Populator" shortcut on your desktop
   OR
   - Run `python skill_populator.py` in terminal

## Customizing Skills

Edit `skills.txt` to add or remove skills. Format:
- One skill per line
- Skills are case-sensitive
- Empty lines are ignored
- No special characters needed

Example:
```
Python (Programming Language)
JavaScript
Project Management
Agile Methodology
```

## Troubleshooting

1. **Python not found**
   - Ensure Python is installed and added to PATH
   - Try running `python --version` in terminal

2. **Chrome won't start in debug mode**
   - Close all Chrome windows first
   - Check if port 9222 is available
   - Try using a different `--user-data-dir`

3. **Skills not being selected**
   - Ensure you're on the correct Workday page
   - Check that the skills input field is visible
   - Verify skills are spelled exactly as they appear in Workday

4. **Installation fails**
   - Run Install.bat as administrator
   - Check internet connection
   - Ensure antivirus isn't blocking installation

## Files Included

- `skill_populator.py` - Main automation script
- `skills.txt` - List of skills to populate
- `requirements.txt` - Python dependencies
- `install.ps1` - PowerShell installation script
- `Install.bat` - Batch file to run installer
- `README.md` - This documentation
- Desktop shortcuts (created by installer):
  - "Chrome Debug Mode"
  - "Run Skill Populator"

## Support

If you encounter any issues:
1. Check the Troubleshooting section above
2. Verify all prerequisites are met
3. Try running the installer again
4. Check the console output for error messages

## Notes

- The script connects to an existing Chrome window
- Waits up to 10 seconds for elements to appear
- Automatically retries failed skill selections
- Creates desktop shortcuts for easy access
- Preserves Chrome profile and settings
