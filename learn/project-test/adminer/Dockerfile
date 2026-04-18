FROM alpine:3.23.3
RUN apk update && apk upgrade --no-cache && apk add --no-cache php-fpm

#expose test 8000
EXPOSE 3366

WORKDIR /var/www/html

#CMD ["php", "-S", "0.0.0.0:8888", "-t", "/var/www/html"]
CMD ["sh", "-c", "tail -f /dev/null"]
