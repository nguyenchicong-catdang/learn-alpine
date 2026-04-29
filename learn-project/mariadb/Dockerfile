FROM alpine:3

RUN apk update && apk upgrade --no-cache && apk add --no-cache mariadb mariadb-client

EXPOSE 3306

COPY ./mariadb.sh /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/mariadb.sh

ENTRYPOINT ["/usr/local/bin/mariadb.sh"]

CMD ["mariadbd", "--user=mysql", "--console", "--bind-address=0.0.0.0", "--skip-networking=0"]

