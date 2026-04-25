FROM alpine:3

RUN apk update && apk upgrade --no-cache && apk add --no-cache php84-fpm php84-mysqli php84-pdo_mysql php84-session

WORKDIR /var/www/html

RUN chmod +x /var/www/html

CMD ["php-fpm84", "-F", "-R"]
