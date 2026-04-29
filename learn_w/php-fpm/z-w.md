php-fpm -D -R

; File: /etc/php84/php-fpm.d/www.conf
clear_env = no

docker exec -it php-fpm-alpine-ncc cat /etc/php84/php-fpm.d/www.conf