python
import asyncio
import logging
from datetime import datetime, timedelta
from aiogram import Bot, Dispatcher, F, types
from aiogram.filters import Command
from aiogram.fsm.storage.memory import MemoryStorage
from aiogram.utils.keyboard import InlineKeyboardBuilder
import aiosqlite

logging.basicConfig(level=logging.INFO)

BOT_TOKEN = "8854104689:AAFls3BF9kswGov1tE0cobVNYATEWx3IMtA"
ADMIN_ID = 1079554097
DB_NAME = "homework.db"

# На Render прокси НЕ нужен!
bot = Bot(token=BOT_TOKEN)
dp = Dispatcher(storage=MemoryStorage())

def get_next_days(count=6):
    days = []
    current = datetime.now()
    while len(days) < count:
        current += timedelta(days=1)
        if current.weekday() < 6:  # Исключаем воскресенье
            days.append(current)
    return days

def get_days_keyboard():
    builder = InlineKeyboardBuilder()
    days = get_next_days(6)
    days_ru = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    for day in days:
        date_str = day.strftime("%Y-%m-%d")
        btn_text = f"{days_ru[day.weekday()]} ({day.strftime('%d.%m')})"
        builder.button(text=btn_text, callback_data=f"day_{date_str}")
    
    builder.adjust(2)
    return builder.as_markup()

@dp.message(Command("start"))
async def cmd_start(message: types.Message):
    await message.answer(
        "Выберите день для просмотра расписания:",
        reply_markup=get_days_keyboard()
    )

async def main():
    await dp.start_polling(bot)

if __name__ == "__main__":
    asyncio.run(main())
