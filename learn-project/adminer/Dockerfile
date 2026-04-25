FROM alpine:3

RUN apk update && apk upgrade --no-cache & apk add --no-cache curl

WORKDIR /app

RUN curl -L https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2-en.php -o /app/adminer.php
