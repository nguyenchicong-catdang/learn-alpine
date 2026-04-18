# user

# Sửa Nginx
RUN sed -i 's/user nginx;/user www-data;/g' /etc/nginx/nginx.conf

# Sửa PHP-FPM
RUN sed -i 's/user = nobody/user = www-data/g' /etc/php84/php-fpm.d/www.conf && \
    sed -i 's/group = nobody/group = www-data/g' /etc/php84/php-fpm.d/www.conf && \
    sed -i 's/;listen.owner = nobody/listen.owner = www-data/g' /etc/php84/php-fpm.d/www.conf && \
    sed -i 's/;listen.group = nobody/listen.group = www-data/g' /etc/php84/php-fpm.d/www.conf && \
    sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php84/php-fpm.d/www.conf


# user RUN addgroup -S www-data && adduser -S www-data -G www-data

run addgroup -S www-data && adduser -S www-data -G www-data

addgroup -S www-data: Tạo một nhóm hệ thống tên là www-data.

adduser -S www-data -G www-data:

-S: Tạo user hệ thống.

-G www-data: Gán ngay user này vào nhóm www-data vừa tạo ở trên.

adduser -S -G www-data -s /sbin/nologin www-data

adduser -S -G www-data -s /sbin/nologin www-data

Luồng hoạt động chuẩn:

Bước 1 (Khai sinh): RUN addgroup -S www-data && adduser -S www-data -G www-data

Lúc này hệ thống đã biết www-data là ai.

Bước 2 (Ủy quyền): USER www-data

Từ dòng này trở đi, mọi lệnh như RUN, CMD, ENTRYPOINT sẽ được chạy dưới quyền của www-data thay vì root.

Lưu ý "Chí mạng" khi dùng USER trong Dockerfile

RUN adduser -S www-data -G www-data

USER www-data

# Tạo user/group (nếu chưa có)
addgroup -S www-data && adduser -S -H -G www-data www-data

# Thêm nginx vào group www-data để nó hưởng quyền '5' trong 750
addgroup nginx www-data

# Phân quyền thư mục code
chown -R www-data:www-data /var/www/html
chmod -R 750 /var/www/html

# Đảm bảo các thư mục run tồn tại
mkdir -p /run/nginx /run/php
chown -R www-data:www-data /run/nginx /run/php

Với Thư mục: Dùng 750
Với File: Dùng 640