_wp-cli-get-core:
	@echo "Creating temporary container to copy files..."
	docker create --name tmp-wp $(WP_CLI_NAME)
	docker cp tmp-wp:/var/www/html $(WP_CLI_PROJECT_PATH)/wordpress-core
	docker rm -f tmp-wp $(WP_CLI_NAME) $(NGINX_CP_HTML)


docker run --network host -it --rm wp-cli-alpine-ncc sh

FROM php:8.4-fpm-alpine

# Cài đặt các gói cần thiết
RUN apk add --no-cache curl

# Tải và cài đặt WP-CLI ngay khi build
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Thiết lập thư mục làm việc
WORKDIR /var/www/html

; File: /etc/php84/php-fpm.d/www.conf
clear_env = no