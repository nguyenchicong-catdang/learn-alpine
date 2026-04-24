FROM alpine:3.23.3
RUN apk update && apk upgrade --no-cache && apk add --no-cache php

#expose test 8888
EXPOSE 8888

WORKDIR /var/www/html

CMD ["php", "-S", "0.0.0.0:8888", "-t", "/var/www/html"]
