from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.core.os_manager import ChromeType
import time
import sys
import os
import platform

class WorkdaySkillPopulator:
    def __init__(self, skills_file_path):
        print("Initializing WorkdaySkillPopulator...")
        self.skills_file_path = skills_file_path
        if not os.path.exists(skills_file_path):
            print(f"Error: Skills file not found at {skills_file_path}")
            print(f"Current directory: {os.getcwd()}")
            sys.exit(1)
        self.driver = None
        self.setup_driver()

    def setup_driver(self):
        """Connect to existing Chrome instance."""
        try:
            print("Setting up Chrome driver...")
            chrome_options = Options()
            chrome_options.add_experimental_option("debuggerAddress", "127.0.0.1:9222")
            
            # Setup ChromeDriver using webdriver_manager with architecture detection
            print("Installing ChromeDriver...")
            try:
                # First try with default settings
                service = Service(ChromeDriverManager().install())
                self.driver = webdriver.Chrome(service=service, options=chrome_options)
            except Exception as chrome_error:
                print(f"First attempt failed: {str(chrome_error)}")
                print("Trying alternative ChromeDriver setup...")
                
                # Get system architecture
                is_64bits = platform.machine().endswith('64')
                if not is_64bits:
                    print("32-bit system detected")
                    # Force 32-bit ChromeDriver
                    os.environ['PROGRAMFILES'] = os.environ.get('PROGRAMFILES(X86)', 'C:\\Program Files (x86)')
                
                # Try again with new settings
                service = Service(ChromeDriverManager(chrome_type=ChromeType.GOOGLE).install())
                self.driver = webdriver.Chrome(service=service, options=chrome_options)
            
            print("Connecting to Chrome...")
            self.wait = WebDriverWait(self.driver, 10)
            
            # Verify connection
            try:
                current_url = self.driver.current_url
                print(f"Connected to Chrome successfully (current URL: {current_url})")
            except Exception as e:
                print("Error accessing Chrome window. Make sure Chrome is running in debug mode.")
                print(f"Error details: {str(e)}")
                sys.exit(1)
                
        except Exception as e:
            print("\nError connecting to Chrome:")
            print(f"Error details: {str(e)}")
            print("\nTroubleshooting steps:")
            print("1. Make sure Chrome is running in debug mode:")
            print("   - Double-click the 'Chrome Debug Mode' shortcut on your desktop")
            print("   - Or run Chrome with: --remote-debugging-port=9222")
            print("2. Check if port 9222 is available")
            print("3. Try closing all Chrome windows and starting again")
            print("4. Make sure you have Chrome installed in the default location")
            print(f"5. System info: {platform.machine()}, {platform.architecture()}")
            sys.exit(1)

    def load_skills(self):
        """Load skills from the specified file."""
        print(f"\nLoading skills from {self.skills_file_path}...")
        try:
            with open(self.skills_file_path, 'r') as file:
                skills = [line.strip() for line in file if line.strip()]
                print(f"Loaded {len(skills)} skills successfully")
                return skills
        except Exception as e:
            print(f"Error loading skills file: {str(e)}")
            sys.exit(1)

    def wait_for_element_interactable(self, element):
        """Wait for an element to become interactable."""
        try:
            self.wait.until(lambda d: element.is_displayed() and element.is_enabled())
            self.driver.execute_script("arguments[0].scrollIntoView(true);", element)
            time.sleep(0.5)
            return True
        except Exception as e:
            print(f"Error waiting for element to be interactable: {str(e)}")
            return False

    def clear_input_field(self, element):
        """Clear input field using multiple methods."""
        try:
            # Combine keyboard shortcuts for faster clearing
            element.send_keys(Keys.CONTROL + "a" + Keys.DELETE)
            time.sleep(0.1)
            
            # Quick JavaScript verification and cleanup if needed
            if self.driver.execute_script("return arguments[0].value !== '';", element):
                self.driver.execute_script("arguments[0].value = '';", element)
            
            return True
        except Exception as e:
            print(f"Error clearing field: {str(e)}")
            return False

    def select_skill_option(self, skill):
        """Select a skill option using JavaScript and direct DOM manipulation."""
        script = """
        function findAndClickCheckbox(searchText) {
            // Helper function to find matching option
            function findMatch(options, exact = true) {
                const searchLower = searchText.toLowerCase();
                return Array.from(options).find(opt => {
                    const text = opt.textContent.trim().toLowerCase();
                    return exact ? text === searchLower : text.includes(searchLower);
                });
            }

            // Get all valid options
            const options = document.querySelectorAll('[role="option"]');
            const validOptions = Array.from(options).filter(opt => {
                const text = opt.textContent.trim();
                return text && text !== 'No Items.';
            });
            
            // Try exact match first
            let matchingOption = findMatch(validOptions, true);
            
            // If no exact match and "Show More" exists, click it
            if (!matchingOption) {
                const showMore = document.querySelector('[data-automation-id="showMore"]');
                if (showMore) {
                    showMore.click();
                    // Get updated options after expanding
                    const allOptions = document.querySelectorAll('[role="option"]');
                    const allValidOptions = Array.from(allOptions).filter(opt => {
                        const text = opt.textContent.trim();
                        return text && text !== 'No Items.';
                    });
                    matchingOption = findMatch(allValidOptions, true) || findMatch(allValidOptions, false);
                }
            }
            
            if (!matchingOption) return false;
            
            // Optimized checkbox interaction
            const checkbox = matchingOption.querySelector('[data-automation-id="checkboxPanel"]');
            if (!checkbox) return false;
            
            // Focus and select in one go
            matchingOption.focus();
            matchingOption.setAttribute('aria-selected', 'true');
            
            // Combine all events into a single dispatch loop
            const events = [
                new MouseEvent('mouseenter', { bubbles: true, cancelable: true, buttons: 1 }),
                new MouseEvent('mouseover', { bubbles: true, cancelable: true, buttons: 1 }),
                new MouseEvent('mousedown', { bubbles: true, cancelable: true, buttons: 1 }),
                new MouseEvent('mouseup', { bubbles: true, cancelable: true, buttons: 1 }),
                new MouseEvent('click', { bubbles: true, cancelable: true, buttons: 1 }),
                new Event('input', { bubbles: true, cancelable: true }),
                new Event('change', { bubbles: true, cancelable: true })
            ];
            
            // Dispatch all events in sequence
            events.forEach(event => checkbox.dispatchEvent(event));
            
            // Set all states at once
            checkbox.checked = true;
            checkbox.setAttribute('aria-checked', 'true');
            checkbox.setAttribute('data-checked', 'true');
            matchingOption.setAttribute('data-selected', 'true');
            
            // Handle Vue.js if present
            if (checkbox.__vue__) {
                checkbox.__vue__.$emit('input', true);
                checkbox.__vue__.$emit('change', true);
            }
            
            return true;
        }
        return findAndClickCheckbox(arguments[0]);
        """
        
        # Single attempt with longer timeout
        try:
            return self.driver.execute_script(script, skill)
        except Exception as e:
            print(f"Error selecting skill option: {str(e)}")
            return False

    def populate_skills(self):
        """Populate skills in the current page."""
        skills = self.load_skills()
        print(f"Processing {len(skills)} skills...")

        # Find the input field once and store it
        try:
            skills_input = self.wait.until(
                EC.presence_of_element_located((By.CSS_SELECTOR, '[data-automation-id="searchBox"]'))
            )
        except Exception as e:
            print(f"Error finding skills input field: {str(e)}")
            sys.exit(1)

        for i, skill in enumerate(skills, 1):
            try:
                if not self.clear_input_field(skills_input):
                    continue

                # Type skill and press enter in one action
                skills_input.send_keys(skill + Keys.RETURN)
                time.sleep(0.5)  # Minimal wait for dropdown

                if self.select_skill_option(skill):
                    print(f"({i}/{len(skills)}) Added: {skill}")
                else:
                    print(f"({i}/{len(skills)}) Failed: {skill}")
                    
            except Exception as e:
                print(f"Error with {skill}: {str(e)}")
                continue

        print("Finished populating skills")

    def close(self):
        """Close the browser connection."""
        if self.driver:
            self.driver.quit()

def main():
    skills_file = "skills.txt"
    populator = None
    
    try:
        populator = WorkdaySkillPopulator(skills_file)
        populator.populate_skills()
    except Exception as e:
        print(f"Error: {str(e)}")
    finally:
        if populator:
            populator.close()

if __name__ == "__main__":
    main()
