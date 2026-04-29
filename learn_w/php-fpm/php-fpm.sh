#!/bin/sh

# cap quyen thuc ghi file /var/www/html/wp-app/wp-content/uploads
mkdir -p /var/www/html/wp-app/wp-content/uploads
chown -R nobody:nobody /var/www/html/wp-app/wp-content/uploads
chmod -R 755 /var/www/html/wp-app/wp-content/uploads

# thoat tra pid 1
exec "$@"