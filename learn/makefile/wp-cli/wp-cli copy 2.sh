#!/bin/sh

# kiem tra bien moi truong .env
if [ -f .env ]; then
    # loc bo comment (#) va export cac bien vao shell
    export $(grep -v '^#' .env | xargs)
fi

# cai dat wp neu chua co
if ! command -v wp >/dev/null 2>&1; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Dowload WordPress neu thu muc app chua co code
if [ ! -f "app/wp-settings.php" ]; then
    php -d memory_limit=512M /usr/local/bin/wp core download --path=app --allow-root
fi

cd app

# su dung .env

if [ ! -f "app/wp-config.php" ]; then
    wp config create \
        --dbhost="${DB_HOST}" \
        --dbname="${DB_DATABASE}" \
        --dbuser="${DB_USERNAME}" \
        --dbpass="${DB_PASSWORD}" \
        --allow-root --force \
        --skip-check  # <--- Quan trọng: Bỏ qua kiểm tra kết nối DB lúc build
else
    wp config update DB_HOST "${DB_HOST}" --allow-root
    wp config update DB_NAME "${DB_DATABASE}" --allow-root
    wp config update DB_USER "${DB_USERNAME}" --allow-root
    wp config update DB_PASSWORD "${DB_PASSWORD}" --allow-root
fi

exec tail -f /dev/null

