# learn-alpine
## xem khoi tao
cat /etc/profile

docker update --restart always nginx-alpine-ncc php-alpine-ncc mariadb-alpine-ncc wp-cli-alpine-ncc

# Cách cài cực nhẹ trên Alpine
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

# Cấu hình Dockerfile "Nghiên cứu"

```Dockerfile
FROM alpine:latest
RUN apk add --no-cache tini

# Script này chỉ đơn giản là giữ container sống mãi mãi
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--"]
# Lệnh cuối cùng là tail -f để container không bao giờ kết thúc
CMD ["sh", "-c", "tail -f /dev/null"]
```

RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

php -d memory_limit=512M /usr/local/bin/wp core download --path=wpdemo

dev: RUN echo "memory_limit=512M" > /etc/php84/conf.d/memory-limit.ini