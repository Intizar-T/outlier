from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from telegram_bot import TelegramBot
import asyncio
import time

EMAIL = "qa_coder_braintrust_0615_367@outlier.ai"
PASSWORD = "Superbombastic@123"
SCRAPE_INTERVAL = 600 # 10 minutes
SCRAPE_COUTNER = SCRAPE_INTERVAL / 60 # times to scrape before sending a message

def main():
    telegram_bot = TelegramBot()
    count = 0
    try:
        while True:
            url = "https://app.outlier.ai/en/expert/login"
            
            # Set up Chrome options
            chrome_options = Options()
            chrome_options.add_argument("--headless")
            chrome_options.add_argument("--disable-gpu")  # Optional: Disable GPU acceleration
            chrome_options.add_argument("--no-sandbox")  # Optional: Bypass OS security model
            chrome_options.add_argument("--disable-dev-shm-usage")  # Optional: Overcome limited resource problems

            driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)
            driver.get(url)

            # Wait for the email input field to be present
            email_input = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.NAME, "email"))
            )
            email_input.send_keys(EMAIL)

            # Wait for the password input field to be present
            password_input = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.NAME, "password"))
            )
            password_input.send_keys(PASSWORD)

            # Wait for the login button to be clickable and click it
            login_button = WebDriverWait(driver, 10).until(
                EC.element_to_be_clickable((By.XPATH, "//button[text()='Login']"))
            )
            login_button.click()

            # Wait for the page to load and check for the text
            task_queue_text = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.XPATH, "//*[contains(text(), 'Your task queue is currently empty')]"))
            )

            if task_queue_text and count % 6 == 0:
                asyncio.run(telegram_bot.send_message("Task queue is empty"))
                count = 0
            else:
                asyncio.run(telegram_bot.send_message("There is a task! Go, go, go!"))
                count = 0
            
            count += 1
            time.sleep(600) # sleep 10 minutes

    except Exception as e:
        print(e)
    finally:
        driver.quit()

if __name__ == "__main__":
    main()