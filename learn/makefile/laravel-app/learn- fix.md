# composer create-project laravel/laravel:^12.0 laravel-app

> composer create-project laravel/laravel:^12.0 laravel-app

# fix extensions
apk upgrade && apk add php composer \
    php-curl \
    php-iconv \
    php-mbstring \
    php-openssl \
    php-zip \
    php-phar \
    php-tokenizer \
    php-session \
    php-xml \
    php-dom \
    php-xmlwriter \
    php-fileinfo \
    php-pdo \
    php-pdo_sqlite \
    php-mysqlnd \
    php-pdo_mysql

cd laravel-app

composer update

php artisan migrate

php artisan key:generate

> phải có php83-mysqlnd và php83-pdo_mysql

php -m | grep mysql

php83-ctype

Ví dụ thực tế trong code
Nếu không có Ctype, bạn phải viết Regex rất mệt:
preg_match('/^[a-z0-9]+$/i', $string)

Có Ctype rồi, bạn chỉ cần:
ctype_alnum($string) — Gọn, nhanh, ít tốn RAM.