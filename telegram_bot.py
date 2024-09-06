from telegram import Bot
import logging

logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=logging.INFO
)
logging.getLogger("httpx").setLevel(logging.WARNING)
logger = logging.getLogger(__name__)

class TelegramBot:
    def __init__(self):
        self.bot_token = "6793894589:AAGiM50exttvWeDgguVshcvaMZX6Zsn6o_8"
        self.channel_id = "-1002384016395"

    async def send_message(self, message):
        bot = Bot(token=self.bot_token)
        await bot.send_message(chat_id=self.channel_id, text=message)

