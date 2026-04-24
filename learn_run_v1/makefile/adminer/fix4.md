apk add nginx php-fpm

mkdir -p run/nginx
mkdir -p run/php

addgroup -S www-data && adduser -S www-data -G www-data

grep "www-data" /etc/group

id www-data

cat /etc/group

adduser -S -H -G www-data www-data

# 775: User(Đọc+Ghi+Chạy), Group(Đọc+Ghi+Chạy), Others(Đọc+Chạy)
find /var/www/html -type d -exec chmod 775 {} +

# 664: User(Đọc+Ghi), Group(Đọc+Ghi), Others(Đọc)
find /var/www/html -type f -exec chmod 664 {} +

chown -R www-data:www-data /var/www/html (Xác định chủ)

chmod -R 775 /var/www/html (Cấp quyền nhanh cho cả hai)