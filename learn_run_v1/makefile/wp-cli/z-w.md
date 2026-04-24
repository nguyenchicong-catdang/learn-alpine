include .env
export # Export tất cả biến trong .env thành biến môi trường

create-config:
	@docker exec -it wp-app-container wp config create \
		--dbname=$(DB_DATABASE) \
		--dbuser=$(DB_USERNAME) \
		--dbpass=$(DB_PASSWORD) \
		--dbhost=$(DB_HOST) \
		--allow-root


RUN wp package install aaemnnosttv/wp-cli-dotenv-command --allow-root

wp config create --dbname=$(wp dotenv get DB_NAME) --dbuser=$(wp dotenv get DB_USER) ...

<?php
require_once __DIR__ . '/vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->safeLoad();

define( 'DB_NAME', $_ENV['DB_DATABASE'] );
define( 'DB_USER', $_ENV['DB_USERNAME'] );
define( 'DB_PASSWORD', $_ENV['DB_PASSWORD'] );
define( 'DB_HOST', $_ENV['DB_HOST'] ?: 'localhost' );

# Đọc file .env bằng PHP rồi truyền vào lệnh
wp config create \
  --dbname=$(grep DB_DATABASE .env | cut -d '=' -f2) \
  --dbuser=$(grep DB_USERNAME .env | cut -d '=' -f2) \
  --dbpass=$(grep DB_PASSWORD .env | cut -d '=' -f2) \
  --dbhost=$(grep DB_HOST .env | cut -d '=' -f2)

#!/bin/sh

# 1. Kiểm tra nếu file .env tồn tại thì load biến
if [ -f .env ]; then
    # Lệnh này sẽ lọc bỏ comment (#) và export các biến vào Shell
    export $(grep -v '^#' .env | xargs)
fi

# 2. Cài đặt WP-CLI (nếu chưa có trong image)
if ! command -v wp >/dev/null 2>&1; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# 3. Download WordPress nếu thư mục app chưa có code
if [ ! -f "app/wp-settings.php" ]; then
    php -d memory_limit=512M /usr/local/bin/wp core download --path=app --allow-root
fi

cd app

# 4. Sử dụng biến từ .env (Ví dụ: DB_NAME, DB_USER...)
# Lưu ý: --dbhost nên dùng tên service của DB trong docker-compose (ví dụ: db) thay vì 127.0.0.1
wp config create \
    --dbname="${DB_DATABASE}" \
    --dbuser="${DB_USERNAME}" \
    --dbpass="${DB_PASSWORD}" \
    --dbhost="${DB_HOST:-127.0.0.1}" \
    --allow-root --force

# Tiếp tục thực thi lệnh chính (CMD) của Docker
exec "$@"


FROM alpine:3.20

# Cài đặt PHP và các extension cần thiết
RUN apk add --no-cache php82 php82-phar php82-mbstring php82-mysqli php82-ctype php82-curl curl

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html

# Thiết lập EntryPoint
ENTRYPOINT ["entrypoint.sh"]

# Mặc định giữ container chạy
CMD ["tail", "-f", "/dev/null"]

#!/bin/sh

# 1. Load biến từ .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# 2. Kiểm tra WP-CLI
if ! command -v wp >/dev/null 2>&1; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# 3. Download WordPress nếu chưa có
if [ ! -f "app/wp-settings.php" ]; then
    # Nhớ thêm lệnh 'core download' ở đây
    php -d memory_limit=512M /usr/local/bin/wp core download --path=app --allow-root
fi

# Di chuyển vào thư mục code
cd app

# 4. Tạo hoặc cập nhật wp-config.php
# Lưu ý: Dùng ${} để gọi biến môi trường
if [ ! -f "wp-config.php" ]; then
    wp config create \
        --dbhost="${DB_HOST}" \
        --dbname="${DB_DATABASE}" \
        --dbuser="${DB_USERNAME}" \
        --dbpass="${DB_PASSWORD}" \
        --allow-root --force
else
    wp config update \
        --dbhost="${DB_HOST}" \
        --dbname="${DB_DATABASE}" \
        --dbuser="${DB_USERNAME}" \
        --dbpass="${DB_PASSWORD}" \
        --allow-root
fi

# 5. Giữ container chạy (Sửa cú pháp exec)
exec tail -f /dev/null

entrypoint: ["sh", "-c", "tail -f /dev/null"]
# Hoặc
command: tail -f /dev/null

docker inspect <container_id>

Tạo file .env

MY_SECRET_TOKEN=your_very_long_token_here

docker run -d --env-file .env my-image

services:
  app:
    image: my-image
    env_file:
      - .env
    # Hoặc nếu muốn chỉ định rõ biến:
    # environment:
    #   - TOKEN=${MY_SECRET_TOKEN}