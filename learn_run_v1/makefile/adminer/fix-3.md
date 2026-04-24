apk add nginx

mkdir -p run/nginx

cat /etc/nginx/nginx.conf

user nginx;

cat /etc/php84/php-fpm.d/www.conf

user = nobody
group = nobody

RUN addgroup -S www-data && adduser -S www-data -G www-data

Bước 2: Sửa Nginx (/etc/nginx/nginx.conf)

user www-data;

Bước 3: Sửa PHP-FPM (/etc/php84/php-fpm.d/www.conf)

user = www-data
group = www-data

; Quan trọng: Quyền sở hữu file socket để Nginx có thể đọc/ghi
listen.owner = www-data
listen.group = www-data
listen.mode = 0660

# Sửa Nginx
RUN sed -i 's/user nginx;/user www-data;/g' /etc/nginx/nginx.conf

# Sửa PHP-FPM
RUN sed -i 's/user = nobody/user = www-data/g' /etc/php84/php-fpm.d/www.conf && \
    sed -i 's/group = nobody/group = www-data/g' /etc/php84/php-fpm.d/www.conf && \
    sed -i 's/;listen.owner = nobody/listen.owner = www-data/g' /etc/php84/php-fpm.d/www.conf && \
    sed -i 's/;listen.group = nobody/listen.group = www-data/g' /etc/php84/php-fpm.d/www.conf && \
    sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php84/php-fpm.d/www.conf

    -S viết tắt của "System": Khi bạn dùng addgroup -S hoặc adduser -S, bạn đang bảo hệ điều hành rằng: "Hãy tạo một Group/User hệ thống".