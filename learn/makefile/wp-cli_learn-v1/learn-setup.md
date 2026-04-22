# https://make.wordpress.org/cli/handbook/guides/installing/

# Cài đặt curl để tải wp-cli
apk add --no-cache curl php-phar

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Cấp quyền và di chuyển vào bin để dùng lệnh 'wp'
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Kiểm tra thử > them php-phar để chạy phar
wp --info

# tham khao
apk add --no-cache \
    php-phar \
    php-iconv \
    php-mbstring \
    php-openssl \
    php-tokenizer

RUN apk add --no-cache \
    php84 \
    php84-phar \
    php84-openssl \
    php84-curl \
    php84-mbstring \
    php84-iconv \
    php84-mysqli \
    curl \
    ca-certificates \
    tar \
    apk add --no-cache php84-gd

# install wp > https://make.wordpress.org/cli/handbook/how-to/how-to-install/

> php-openssl => để tải curl mã hóa http/https

wp core download --path=wpdemo --locale=it_IT

> php -d memory_limit=512M /usr/local/bin/wp core download --path=wpdemo

cd wpdemo

> apk add php-mysqli

wp config create --dbname=test --dbuser=test --dbpass=123456 --dbhost=127.0.0.1 --allow-root

wp config create --dbname=test --dbuser=test --dbpass=123456 --dbhost=127.0.0.1

> apk add --no-cache mariadb-client

wp db create

-> nếu tồn tại
wp db check

-> xoa
wp db reset --yes

> apk add php-mbstring

wp core install --url=127.0.0.1:8080 --title="WP-CLI" --admin_user=test --admin_password=123456 --admin_email=info@wp-cli.org

> apk add --no-cache php-gd