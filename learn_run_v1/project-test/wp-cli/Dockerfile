FROM alpine:3.23

RUN apk update && apk upgrade --no-cache && apk add --no-cache curl php84 php84-phar php84-curl php84-openssl php84-iconv php84-mbstring php84-tokenizer php84-mysqli ca-certificates tar mariadb-client

# tao app trong html
WORKDIR /var/www/html

# copy wp-cli.sh
COPY wp-cli.sh /usr/local/bin/wp-cli.sh
#RUN chmod +x /usr/local/bin/wp-cli.sh
RUN chmod +x /usr/local/bin/wp-cli.sh && /usr/local/bin/wp-cli.sh
# 2. Ghi đè file config "thông minh" của bạn vào
COPY wp-config.php /var/www/html/app/wp-config.php
#ENTRYPOINT ["wp-cli.sh"]
