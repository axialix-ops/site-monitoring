#!/bin/bash

# Получаем путь к текущему скрипту
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# Перейдём в эту папку
cd "$SCRIPT_DIR" || exit 1

# Проверка наличия Docker
if ! command -v docker &> /dev/null; then
    echo "Docker не установлен."
    exit 1
fi

# Проверка наличия Python3 и pip3
if ! command -v python3 &> /dev/null; then
    echo "Python3 не установлен."
    exit 1
fi

if ! command -v pip3 &> /dev/null; then
    echo "pip3 не установлен."
    exit 1
fi

# Установка библиотеки requests
echo "Проверяем наличие библиотеки requests..."
if ! pip3 show requests &> /dev/null; then
    echo "Установка библиотеки requests..."
    pip3 install requests
fi

# Проверка наличия файла sites.txt
if [ ! -f "sites.txt" ]; then
    echo "Файл sites.txt не найден. Создайте его и запишите URL сайтов."
    exit 1
fi

# Проверка наличия папки assembling/
if [ ! -d "assembling" ]; then
    echo "Папка 'assembling' не найдена."
    exit 1
fi

# Проверка наличия prometheus.yml
if [ ! -f "assembling/prometheus.yml" ]; then
    echo "Файл 'assembling/prometheus.yml' не найден."
    exit 1
fi

# Остановим старые контейнеры, если они есть
docker compose -f assembling/docker-compose.yml down

# Запустим всё через Docker Compose
docker compose -f assembling/docker-compose.yml up -d

# Проверим, что контейнеры запущены
sleep 5
if ! docker ps | grep -q 'prometheus'; then
    echo "Ошибка: Не удалось запустить контейнеры."
    exit 1
fi

# Запустим Python-скрипт в фоне
nohup python3 mon.py > monitor.log 2>&1 &

echo "Все сервисы и скрипт запущены. Логи в monitor.log"
