
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys


from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from telegram_bot import TelegramBot

EMAIL = "qa_coder_braintrust_0615_367@outlier.ai"
PASSWORD = "Superbombastic@123"

class Scraper():
    def __init__(self, driver):
        self.driver = driver

    def run(self):
        try:
            url = "https://app.outlier.ai/en/expert/login"
            
            self.driver.get(url)

            # Wait for the email input field to be present
            email_input = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.NAME, "email"))
            )
            email_input.send_keys(EMAIL)

            # Wait for the password input field to be present
            password_input = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.NAME, "password"))
            )
            password_input.send_keys(PASSWORD)

            # Wait for the login button to be clickable and click it
            login_button = WebDriverWait(self.driver, 10).until(
                EC.element_to_be_clickable((By.XPATH, "//button[text()='Login']"))
            )
            login_button.click()

            # Wait for the page to load and check for the text
            task_queue_text = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.XPATH, "//*[contains(text(), 'Your task queue is currently empty')]"))
            )

            if task_queue_text:
                return False
            else:
                return True
            
        except Exception as e:
            print(e)
            return False