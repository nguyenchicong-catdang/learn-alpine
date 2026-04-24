ls /usr/sbin

php-fpm84

/usr/sbin/php-fpm84 --version

ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm

docker exec -it wp-app-alpine-ncc php -r "echo getenv('DB_DATABASE');"

php-fpm -r "echo getenv('DB_DATABASE');"

vi /etc/nginx/http.d/default.conf

echo "<?php var_dump(getenv('DB_DATABASE')); ?>" > test_env.php

CMD ["nginx", "-g", "daemon off;"]

volumes:
   - default.conf:/etc/nginx/http.d/default.conf
  # CMD => Dockerfile
  #command: ["sh", "-c", "tail -f >/dev/null"]
  command: tail -f /dev/null


RUN chmod +x /var/www/html

command: nginx -g "daemon off;"

/var/www/html # ls /var/log/nginx
access.log  error.log

tail -f /var/log/nginx/error.log

ps aux | grep php-fpm

/etc/php84/php-fpm.d/www.conf

/etc/php/php-fpm.d/www.conf


cat //etc/php84/php-fpm.d/www.conf

clear_env = no/

yes

clear_env = no

php-fpm -D -R

pkill php-fpm

command: sh -c "php-fpm84 -D -R && nginx -g 'daemon off;'"

entrypoint.sh:

#!/bin/sh
# 1. Sửa lỗi quyền hạn nếu cần
# chown -R www-data:www-data /var/www/html

# 2. Khởi động PHP-FPM ở chế độ daemon (chạy ngầm)
php-fpm84 -D -R

# 3. Khởi động Nginx ở chế độ foreground (tiến trình chính)
nginx -g "daemon off;"

# Ví dụ trong Dockerfile
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

services:
  wp-app:
    entrypoint: /var/www/html/entrypoint.sh


#!/bin/sh
set -e # Dừng script ngay nếu có lệnh nào bị lỗi

# 1. Các lệnh Init (Chạy 1 lần khi container start)
echo "Đang khởi động PHP-FPM..."
php-fpm84 -D -R

# 2. Kiểm tra file cấu hình Nginx trước khi chạy
nginx -t

echo "Đang khởi động Nginx..."
# 3. Sử dụng 'exec' để Nginx trở thành PID 1 (để Docker quản lý tốt nhất)
exec nginx -g "daemon off;"


wp-app:
    init: true
    entrypoint: /var/www/html/entrypoint.sh

command: sh -c "php-fpm84 -D -R && exec nginx -g 'daemon off;'"

#!/bin/sh
# Dọn dẹp tàn dư nếu lần trước cúp điện đột ngột
rm -f /var/run/php-fpm.sock

# Khởi động FPM chạy ngầm
php-fpm84 -D -R

# Khởi động Nginx và dùng exec để nó chiếm PID chính
exec nginx -g "daemon off;"

sed -i 's/^;*clear_env =.*/clear_env = no/' /etc/php84/php-fpm.d/www.conf

location /app/ {
    index index.php;
    try_files $uri $uri/ /app/index.php?$args;
}

location ~ \.php$ {
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    include fastcgi_params;
    # Quan trọng: Đảm bảo SCRIPT_FILENAME trỏ đúng root
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}


define('WP_HOME', 'http://localhost:8080/app');
define('WP_SITEURL', 'http://localhost:8080/app');

// Fix lỗi redirect khi chạy đằng sau Proxy/Docker port mapping
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}