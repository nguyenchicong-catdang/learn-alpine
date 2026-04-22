FROM wp-cli-alpine-ncc AS source_code_wp-cli-alpine-ncc
# learn app => /var/www/html/app
WORKDIR /var/www/html/app

# tao image moi
FROM alpine:3.23
# cai dat
RUN apk update && apk upgrade --no-cache && apk add --no-cache nginx php84-fpm
# thiet lap thu muc lam viec
WORKDIR /var/www/html
# Cú pháp: --from=[name_stage] [path_source] [path_target]
COPY --from=source_code_wp-cli-alpine-ncc /var/www/html/app /var/www/html/app
# copy config
COPY wp-config.php /var/www/html/app/wp-config.php
