FROM alpine:3

RUN apk update && apk upgrade --no-cache && apk add --no-cache mariadb mariadb-client

RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld && chmod -R 750 /run/mysqld

EXPOSE 3306

CMD ["mariadbd", "--user=mysql", "--console", "--bind-address=0.0.0.0", "--skip-networking=0"]

