php-fpm -D -R

; File: /etc/php84/php-fpm.d/www.conf
clear_env = no

docker exec -it php-fpm-alpine-ncc cat /etc/php84/php-fpm.d/www.conf


define PHP_FPM_DOCKERFILE
FROM $(ALPINE_IMAGE)

RUN apk update && apk upgrade --no-cache && \
    apk add --no-cache \
        php84-fpm \
        php84-mysqli \
        php84-pdo_mysql \
        php84-session \
        php84-json \
        php84-curl \
        php84-gd \
        php84-dom \
        php84-xml \
        php84-xmlreader \
        php84-xmlwriter \
        php84-mbstring \
        php84-openssl \
        php84-tokenizer \
        php84-ctype \
        php84-intl

# Tạo symlink để lệnh php-fpm84 có thể chạy như php-fpm (tùy chọn)
RUN ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm

WORKDIR /var/www/html

# Nên để quyền sở hữu cho user chạy php-fpm (thường là nobody trong Alpine)
RUN chown -R nobody:nobody /var/www/html

CMD ["php-fpm84", "-F", "-R"]
endef

error.log

/var/www/html # cat /var/log/php84/error.log
[29-Apr-2026 03:24:15] NOTICE: fpm is running, pid 1
[29-Apr-2026 03:24:15] NOTICE: ready to handle connections
/var/www/html # 

# Thay đổi upload_max_filesize
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /etc/php84/php.ini

# Thay đổi post_max_size (luôn phải >= upload_max_filesize)
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /etc/php84/php.ini

docker exec -it php-fpm-alpine-ncc cat /etc/php84/php.ini

upload_max_filesize = 2M

docker exec php-fpm-alpine-ncc ls -la /var/www/html/wp-app/wp-content/

docker exec -u root php-fpm-alpine-ncc chown -R nobody:nobody /var/www/html

## fix 
#!/bin/sh
# Tự động sửa quyền cho thư mục uploads mỗi khi khởi động
chown -R nobody:nobody /var/www/html/wp-app/wp-content/uploads
chmod -R 775 /var/www/html/wp-app/wp-content/uploads

# Chạy lệnh chính của PHP-FPM
exec "$@"

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Sử dụng entrypoint
ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm84", "-F", "-R"]

docker exec -u root php-fpm-alpine-ncc chmod -R 775 /var/www/html/wp-app/wp-content/uploads