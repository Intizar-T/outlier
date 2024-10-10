from selenium.webdriver.chrome.options import Options

def chrome_options(headless=True):
    # Set up Chrome options
    chrome_options = Options()
    if headless:
        chrome_options.add_argument("--headless")
    chrome_options.add_argument("--disable-gpu")  # Optional: Disable GPU acceleration
    chrome_options.add_argument("--no-sandbox")  # Optional: Bypass OS security model
    chrome_options.add_argument("--disable-dev-shm-usage")  # Optional: Overcome limited resource problems
    return chrome_options