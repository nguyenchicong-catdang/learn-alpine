.DEFAULT_GOAL :=help

IMAGE_NAME = wp-cli-alpine-ncc

.PHONY: all check-build next

# Task chính: Chạy kiểm tra rồi mới làm bước tiếp theo
all: check-build next

check-build:
	@if [ -z "$$(docker images -q $(IMAGE_NAME) 2> /dev/null)" ]; then \
		echo "Image $(IMAGE_NAME) không tồn tại. Đang tiến hành build..."; \
		docker build -t $(IMAGE_NAME) . ; \
	else \
		echo "Image $(IMAGE_NAME) đã tồn tại. Bỏ qua bước build."; \
	fi

next:
	@echo "Đang thực hiện các bước tiếp theo (ví dụ: docker-compose up)..."
	docker compose up -d


--network host \

_wp-app-prepare:
	@if [ -n "$$(docker images -q $(WP_CLI_IMAGE_NAME) 2>/dev/null)" ]; then \
		echo "Ket qua NOT NULL: Image da ton tai!"; \
	else \
		echo "Ket qua NULL: Image chua co!"; \
	fi


# STAGE 1: Sử dụng image build sẵn của bạn làm "kho chứa" code
FROM wp-cli-alpine-ncc AS source_code

# Giả sử code của bạn nằm trong thư mục này của image wp-cli-alpine-ncc
WORKDIR /var/www/html/app


# STAGE 2: Image thực tế để chạy ứng dụng (ví dụ dùng alpine hoặc php-fpm)
FROM php:8.2-fpm-alpine

# Cài đặt các thư viện cần thiết cho WordPress/Laravel (nếu cần)
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Thiết lập thư mục làm việc cho web server
WORKDIR /var/www/html

# COPY code từ STAGE source_code vào image mới này
# Cú pháp: --from=[tên_stage] [đường_dẫn_nguồn] [đường_dẫn_đích]
COPY --from=source_code /var/www/html/app /var/www/html/app

# Phân quyền cho user www-data (quan trọng để tránh lỗi 403/500)
RUN chown -R www-data:www-data /var/www/html/app

USER www-data

CMD ["php-fpm"]

    network_mode: "bridge"
    network_mode: "host"
    network_mode: "none"
    network_mode: "service:[service name]"



--project-directory


DB_CONNECTION=sqlite
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=laravel
# DB_USERNAME=root
# DB_PASSWORD=


	docker build --network host -t $(WP_APP_IMAGE_NAME) -f $(WP_APP_PROJECT_PATH)/Dockerfile $(WP_APP_PROJECT_PATH)


# Download WordPress nếu chưa có code
if [ ! -f "app/wp-settings.php" ]; then
    echo "Dang tai WordPress..."
    # Thêm 'core download' và '512M'
    php -d memory_limit=512M /usr/local/bin/wp core download --path=app --allow-root
fi


FROM alpine:3.20
# ... cài đặt PHP, curl, v.v. ...

COPY build-wp.sh /usr/local/bin/build-wp.sh
RUN chmod +x /usr/local/bin/build-wp.sh && /usr/local/bin/build-wp.sh

WORKDIR /var/www/html/app


ls -la /var/www/html/app/wp-config.php

touch /var/www/html/app/test-write.txt && rm /var/www/html/app/test-write.txt

wp config create \
    --dbname="${DB_DATABASE}" \
    --dbuser="${DB_USERNAME}" \
    --dbpass="${DB_PASSWORD}" \
    --dbhost="${DB_HOST}" \
    --allow-root \
    --skip-check --force

# Stage 1: Chỉ chuyên tải WP và tạo Config mẫu
FROM wp-cli-alpine-ncc AS wp_source
WORKDIR /var/www/html/app
RUN wp core download --allow-root
# Tạo config sẵn ở đây (dùng --skip-check)
RUN wp config create --skip-check --dbname=db --dbuser=user --dbpass=pass --allow-root

# Stage 2: Image chạy App chính (Nginx/PHP-FPM)
FROM alpine:3.21
WORKDIR /var/www/html/app
# Copy toàn bộ "thành quả" từ Stage 1 sang
COPY --from=wp_source /var/www/html/app .


define( 'DB_NAME', getenv('DB_DATABASE') );
define( 'DB_USER', getenv('DB_USERNAME') );