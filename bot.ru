import os
import logging
from dotenv import load_dotenv
from telegram import Update, ReplyKeyboardMarkup
from telegram.ext import Application, CommandHandler, MessageHandler, filters, ContextTypes, ConversationHandler

# --- 1. Загружаем токен из .env файла ---
load_dotenv()
TOKEN = os.getenv('BOT_TOKEN')

# --- 2. Настройка логирования ---
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

# --- 3. Определяем состояния для разговора (пока не используем) ---
MAIN_MENU, VIEW_CATEGORY, ADD_ITEM, REMOVE_ITEM = range(4)

# --- 4. Создаем клавиатуру главного меню ---
def get_main_keyboard():
    keyboard = [
        ['📦 Посмотреть склад'],
        ['➖ Списать позицию'],
        ['📋 Что заказать?'],
        ['📥 Внести закупку']
    ]
    return ReplyKeyboardMarkup(keyboard, resize_keyboard=True)

# --- 5. Обработчики команд ---

# Команда /start
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user
    await update.message.reply_text(
        f'Привет, {user.first_name}! 👋\n'
        f'Добро пожаловать в "СкладСтом" — систему учета для стоматологий.\n\n'
        f'Выберите действие:',
        reply_markup=get_main_keyboard()
    )
    return MAIN_MENU

# Показ склада (заглушка)
async def show_warehouse(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        '📊 **Текущие остатки на складе:**\n\n'
        '🔹 **Материалы:**\n'
        '• Пломбировочный материал Spectra A2 - 4 шт.\n'
        '• Ортофосфорная кислота - 1 шт.\n\n'
        '🔹 **Расходники:**\n'
        '• Перчатки M - 100 шт.\n'
        '• Маски 3-слойные - 50 шт.\n\n'
        '⚠️ *Это тестовые данные. Реальный склад будет подключен позже.*',
        parse_mode='Markdown'
    )

# Обработка нажатий на кнопки
async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    text = update.message.text
    
    if text == '📦 Посмотреть склад':
        await show_warehouse(update, context)
    elif text == '➖ Списать позицию':
        await update.message.reply_text('Функция "Списать позицию" в разработке... 🛠️')
    elif text == '📋 Что заказать?':
        await update.message.reply_text('Функция "Что заказать?" в разработке... 🛠️')
    elif text == '📥 Внести закупку':
        await update.message.reply_text('Функция "Внести закупку" в разработке... 🛠️')
    else:
        await update.message.reply_text(
            'Пожалуйста, используйте кнопки меню 👇',
            reply_markup=get_main_keyboard()
        )

# Команда /help
async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        '❓ **Помощь по боту:**\n\n'
        '• /start - Показать главное меню\n'
        '• /help - Эта справка\n\n'
        '📌 Используйте кнопки меню для навигации.\n'
        'Бот находится в активной разработке.',
        parse_mode='Markdown'
    )

# --- 6. Главная функция ---
def main():
    # Создаем приложение
    application = Application.builder().token(TOKEN).build()
    
    # Регистрируем команды
    application.add_handler(CommandHandler("start", start))
    application.add_handler(CommandHandler("help", help_command))
    
    # Обработчик текстовых сообщений (кнопок)
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    
    # Запускаем бота
    logger.info("Бот запускается...")
    application.run_polling(allowed_updates=Update.ALL_TYPES)

if __name__ == '__main__':
    main()
