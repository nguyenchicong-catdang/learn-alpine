FROM wp-cli-alpine-ncc AS source_code_wp-cli-alpine-ncc
# learn app => /var/www/html/app
WORKDIR /var/www/html/app

# tao image moi
FROM alpine:3.23
# cai dat
RUN apk update && apk upgrade --no-cache && apk add --no-cache nginx php84-fpm php84-mysqli
# thiet lap thu muc lam viec
WORKDIR /var/www/html
# Cú pháp: --from=[name_stage] [path_source] [path_target]
COPY --from=source_code_wp-cli-alpine-ncc /var/www/html/app /var/www/html/app
# copy config
COPY wp-config.php /var/www/html/app/wp-config.php
# xu ly php-fpm84
RUN ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm && ln -s /etc/php84 /etc/php && sed -i 's/^;*clear_env =.*/clear_env = no/' /etc/php/php-fpm.d/www.conf

# test
COPY index.html /var/www/html/index.html
COPY phpinfo.php /var/www/html/phpinfo.php
COPY test-env.php /var/www/html/test-env.php
# cap quyen nginx /var/www/html
# RUN chmod +x /var/www/html
