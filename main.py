from telegram_bot import TelegramBot
import asyncio

def main():
    telegram_bot = TelegramBot()
    asyncio.run(telegram_bot.send_message("Hello, World!"))

if __name__ == "__main__":
    main()

# import requests

# # Replace 'YOUR_BOT_TOKEN' with your actual bot token
# bot_token = '6793894589:AAGiM50exttvWeDgguVshcvaMZX6Zsn6o_8'
# url = f'https://api.telegram.org/bot{bot_token}/getUpdates'

# response = requests.get(url)
# data = response.json()

# # Extract the group ID from the response
# if 'result' in data:
#     for update in data['result']:
#         if 'message' in update:
#             chat_id = update['message']['chat']['id']
#             chat_type = update['message']['chat']['type']
#             if chat_type == 'group' or chat_type == 'supergroup':
#                 print(f"Group ID: {chat_id}")
#                 break
# else:
#     print("No updates found")