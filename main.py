from telegram_bot import TelegramBot
from scrape import Scraper
import asyncio
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from utils import chrome_options
# import time
# import threading

# SCRAPE_INTERVAL = 600 # 10 minutes
# SCRAPE_COUTNER = 1 * SCRAPE_INTERVAL / 60 # times to scrape before sending a message

def main():
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options())
    scraper = Scraper(driver=driver)
    telegram_bot = TelegramBot(scraper=scraper)

    # def run_scraper():
    # count = 0
    # while True:
    #     if scraper.run():
    #         asyncio.run(telegram_bot.send_message("Tasks! Go, go, go!"))
    #         count = 0
    #     elif count % SCRAPE_COUTNER == 0:
    #         asyncio.run(telegram_bot.send_message("EQ"))
    #         count = 0

    #     count += 1
    #     time.sleep(SCRAPE_INTERVAL)

    # threading.Thread(target=run_scraper).start()

    # telegram_bot.run()

    if scraper.run():
        asyncio.run(telegram_bot.send_message("Tasks! Go, go, go!"))
    else:
        asyncio.run(telegram_bot.send_message("EQ"))

if __name__ == "__main__":
    main()