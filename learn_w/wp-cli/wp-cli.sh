#!/bin/sh

WP_CLI_URL="https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"
# Tai wp
curl -O $WP_CLI_URL
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

php -d memory_limit=512M /usr/local/bin/wp core download --path=/root/wp-app --allow-root