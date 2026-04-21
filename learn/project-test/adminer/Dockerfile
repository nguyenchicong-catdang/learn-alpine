FROM alpine:3.23.3
RUN apk update && apk upgrade --no-cache && apk add --no-cache nginx php84-fpm php84-mysqli php84-session

# Copy file cấu hình và entrypoint
COPY adminer.sh /usr/local/bin/adminer.sh
RUN chmod +x /usr/local/bin/adminer.sh

#expose test 8000
EXPOSE 3366

WORKDIR /var/www/html

ENTRYPOINT ["adminer.sh"]

#CMD ["php", "-S", "0.0.0.0:8888", "-t", "/var/www/html"]
#CMD ["sh", "-c", "tail -f /dev/null"]
