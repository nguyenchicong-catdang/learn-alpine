#!/bin/sh
set -e

echo "Khởi tạo Adminer..."

# Kiểm tra nếu chưa có file index.php của Adminer thì tải về (ví dụ)
if [ ! -f /var/www/html/index.php ]; then
    echo "Đang tải Adminer..."
    # Lệnh tải adminer ở đây nếu cần
fi

echo "Bắt đầu chạy PHP-FPM..."
# link php84 => php fpm /usr/sbin
ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm
ln -s /etc/php84 /etc/php
# tao thu muc lam viec
mkdir -p /run/nginx
mkdir -p /run/php-fpm
# cap quyen nginx
chmod -R 755 /var/www/html
chown -R nginx:nginx /var/www/html


# Chạy php-fpm ở background và sau đó chạy nginx ở foreground
php-fpm -D 2>/dev/null || true
echo "Bắt đầu chạy Nginx..."
nginx -g "daemon off;" 2>/dev/null || true

# dev
exec tail -f /dev/null/