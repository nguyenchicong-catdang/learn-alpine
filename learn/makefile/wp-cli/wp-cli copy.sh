#!/bin/sh

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar

mv wp-cli.phar /usr/local/bin/wp

php -d memory_limit=512M /usr/local/bin/wp core download --path=app

cd app

wp config create --dbname=test --dbuser=test --dbpass=123456 --dbhost=127.0.0.1