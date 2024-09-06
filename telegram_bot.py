from telegram import Bot
import logging
from telegram import Update
from telegram.ext import (
    Application,
    CommandHandler,
    ContextTypes,
    MessageHandler,
    filters,
)

logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=logging.INFO
)
logging.getLogger("httpx").setLevel(logging.WARNING)
logger = logging.getLogger(__name__)

COMMANDS = [
    "/ping",
    "/commands",
    "/check_eq"
]

class TelegramBot:
    def __init__(self, scraper):
        self.bot_token = "6793894589:AAGiM50exttvWeDgguVshcvaMZX6Zsn6o_8"
        self.channel_id = "-1002384016395"
        self.scraper = scraper

    async def send_message(self, message):
        bot = Bot(token=self.bot_token)
        await bot.send_message(chat_id=self.channel_id, text=message)
    
    async def handle_message(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        logger.info(f"Received message: {update.message.text} from {update.effective_chat.id}")
        await update.message.reply_text(f"Received: {update.message.text}")
    
    async def pong(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        logger.info(f"Received /ping command from {update.effective_chat.id}")
        await update.message.reply_text("Pong!")
    
    async def commands(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        logger.info(f"Received /commands command from {update.effective_chat.id}")
        commands_list = "\n".join(COMMANDS)
        await update.message.reply_text(f"Komandalar: \n{commands_list}")
    
    async def check_eq(self, update: Update, context: ContextTypes.DEFAULT_TYPE):
        logger.info(f"Received /check_eq command from {update.effective_chat.id}")

        if self.scraper.run():
            await update.message.reply_text("Tasks! Go, go, go!")
        else:
            await update.message.reply_text("EQ")
    
    def run(self):
        application = Application.builder().token(self.bot_token).build()
        application.add_handler(CommandHandler("ping", self.pong))
        application.add_handler(CommandHandler("commands", self.commands))
        application.add_handler(CommandHandler("check_eq", self.check_eq))
        application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, self.handle_message))

        # Run the bot until the user presses Ctrl-C
        application.run_polling(allowed_updates=Update.ALL_TYPES)