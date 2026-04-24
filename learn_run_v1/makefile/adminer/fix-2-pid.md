supervisor

[supervisord]
nodaemon=true
user=root

[program:php-fpm]
command=php-fpm84 -F
autostart=true
autorestart=true

[program:nginx]
command=nginx -g "daemon off;"
autostart=true
autorestart=true

#!/bin/sh
# Khởi động PHP-FPM (chạy ngầm)
php-fpm84 &

# Khởi động Nginx (chạy ở foreground - làm PID 1 giả)
nginx -g "daemon off;"

location ~ \.php$ {
    fastcgi_pass unix:/run/php/php-fpm.sock;
    fastcgi_index index.php;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]


#!/bin/sh
set -e

# 1. Đảm bảo thư mục run tồn tại và đúng quyền
mkdir -p /run/php
chown -R www-data:www-data /run/php

# 2. Khởi động PHP-FPM ở chế độ chạy ngầm (Background)
echo "Starting PHP-FPM..."
php-fpm84

# 3. Khởi động Nginx ở chế độ Foreground (Tiến trình chính)
echo "Starting Nginx..."
exec nginx -g "daemon off;"


define DOCKERFILE_CONTENT_DEV
FROM $(IMAGE_ALPINE)

# Cài đặt các package cần thiết
RUN apk add --no-cache php84-fpm nginx tini

# Tạo link (như đã bàn ở trên)
RUN ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Khai báo sử dụng tini
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]
endef


define ENTRYPOINT_CONTENT
#!/bin/sh
php-fpm84
exec nginx -g "daemon off;"
endef
export ENTRYPOINT_CONTENT

_adminer-create-entrypoint:
	@echo "$$ENTRYPOINT_CONTENT" > $(ADMINER_PATH_APP)/entrypoint.sh
	chmod +x $(ADMINER_PATH_APP)/entrypoint.sh