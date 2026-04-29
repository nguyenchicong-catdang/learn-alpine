FROM alpine:3

RUN apk update && apk upgrade --no-cache && apk add --no-cache php84-fpm php84-mysqli php84-pdo_mysql php84-session php84-gd


WORKDIR /var/www/html

RUN chown -R nobody:nobody /var/www/html && chmod -R 755 /var/www/html

# entrypoint
COPY ./php-fpm.sh /usr/local/bin/php-fpm.sh
RUN chmod +x /usr/local/bin/php-fpm.sh

ENTRYPOINT ["/usr/local/bin/php-fpm.sh"]

CMD ["php-fpm84", "-F", "-R"]
