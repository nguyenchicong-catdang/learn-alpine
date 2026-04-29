#!/bin/sh

# Tao thu muc can thiet
mkdir -p /run/mysqld /var/lib/mysql

# Phan quyen
chown -R mysql:mysql /run/mysqld /var/lib/mysql
chmod -R 750 /run/mysqld /var/lib/mysql

# Kiem tra neu chwa co database he thong thi moi khoi tao
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    # Dam bao quyen han cho cac file vua khoi tao
    chown -R mysql:mysql /var/lib/mysql
fi

# Chay lenh tiep theo (vi du: mariadbd-safe)
exec "$@"