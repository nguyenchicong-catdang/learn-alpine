# tao link
ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm

php-fpm -v

RUN ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm

# Tạo link để gõ php-fpm cho ngắn
RUN ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm

# Tạo thư mục run và cấp quyền (tránh lỗi không ghi được PID)
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php

# Chạy php-fpm ở chế độ Foreground
CMD ["php-fpm84", "-F"]

which php84      # Kiểm tra bộ thực thi lệnh CLI
which php-fpm84  # Kiểm tra bộ quản lý tiến trình web

cat /etc/php84/php-fpm.d/www.conf

user = nobody
group = nobody

;   '/path/to/unix/socket' - to listen on a unix socket.
; Note: This value is mandatory.
listen = 127.0.0.1:9000

sed -i 's/user = nobody/user = www-data/g' /etc/php84/php-fpm.d/www.conf
sed -i 's/group = nobody/group = www-data/g' /etc/php84/php-fpm.d/www.conf

# Tạo link cho thư mục cấu hình
ln -s /etc/php84 /etc/php

# Tạo link cho binary và config
RUN ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm && \
    ln -s /etc/php84 /etc/php

# Sau này bạn có thể gọi file cực kỳ ngắn gọn:
# /etc/php/php.ini
# /etc/php/php-fpm.conf

netstat -lntp | grep :9000
# Hoặc dùng ps
ps aux | grep php

listen.owner = www-data
listen.group = www-data
listen.mode = 0660

Sửa thành: listen = /run/php/php-fpm.sock

listen.owner = www-data
listen.group = www-data
listen.mode = 0660

# Tải bản Adminer mới nhất (tiếng Anh) vào thư mục hiện tại
curl -L https://www.adminer.org/latest-en.php -o adminer.php

wget https://www.adminer.org/latest-en.php -O adminer.php

RUN mkdir -p /run/php && chown -R www-data:www-data /run/php