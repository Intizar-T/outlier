from telegram_bot import TelegramBot
from scrape import Scraper
import asyncio
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from utils import chrome_options
import time

SCRAPE_INTERVAL = 600 # 10 minutes

def main():
    driver = webdriver.Chrome(
        service=Service(ChromeDriverManager().install()),
        options=chrome_options(headless=True)
    )
    scraper = Scraper(driver=driver)
    scraper.login()

    telegram_bot = TelegramBot(scraper=scraper)

    while True:
        if scraper.run():
            asyncio.run(telegram_bot.send_message("Tasks! Go, go, go!"))
        # else:
        #     asyncio.run(telegram_bot.send_message("EQ"))
        
        time.sleep(SCRAPE_INTERVAL)

if __name__ == "__main__":
    main()