["sh", "-c", "tail -f /dev/null"]

php-fpm -D -R
-D (Daemonize)
CMD ["php-fpm84", "-D", "-R"]

Đúng: CMD ["/usr/sbin/php-fpm84", "-F", "-R"]


netstat -tulpn | grep :9000

docker inspect <container_id>

docker run -d --env-file .env my-image

/usr/sbin/sshd -D

Tham số để Docker sống	-F (Foreground).	-D (Do not detach).

/etc/php84/php-fpm.d/www.conf

vi /etc/php84/php-fpm.d/www.conf

docker restart php-fpm-alpine-ncc


curl -L https://www.adminer.org/latest-en.php -o adminer.php

docker run --rm -it admine-alpine-ncc sh

# 1. Tạo container tạm thời từ image
docker create --name temp_box admine-alpine-ncc

# 2. Copy thư mục /app từ container ra thư mục hiện tại của máy host
docker cp temp_box:/app ./app

# 3. Xóa container tạm thời
docker rm temp_box

# Trong Dockerfile của PHP
RUN apk add --no-cache php84-mysqli php84-pdo_mysql php84-session

CMD ["mariadbd", "--user=mysql", "--console", "--bind-address=0.0.0.0", "--skip-networking=0"]

docker exec -u root mariadb-alpine-ncc mkdir -p /run/mysqld
docker exec -u root mariadb-alpine-ncc chown mysql:mysql /run/mysqld

docker restart mariadb-alpine-ncc

docker exec php-fpm-alpine-ncc php -m | grep -E "mysqli|pdo_mysql|session"

mariadbd --user=mysql

# 1. Truy cập vào MariaDB bằng quyền root hệ thống (không cần pass)
docker exec -it mariadb-alpine-ncc mariadb -u root

# 2. Chạy lệnh SQL sau (Copy từng dòng)
# Lệnh này chuyển cơ chế xác thực sang mật khẩu bình thường và đặt mật khẩu là TRỐNG
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('');
ALTER USER 'root'@'127.0.0.1' IDENTIFIED VIA mysql_native_password USING PASSWORD('');

# Cấp quyền tối cao cho root để có thể đăng nhập từ mọi nơi
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION;

# Lưu thay đổi
FLUSH PRIVILEGES;
EXIT;


init.sql

ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('');
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;


COPY init.sql /docker-entrypoint-initdb.d/

docker exec -it mariadb-alpine-ncc mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD(''); GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION; FLUSH PRIVILEGES;"

docker exec -it mariadb-alpine-ncc mariadb -u root -e "SHOW DATABASES;"

.env
DB_ROOT_PASSWORD=      # Để trống nếu muốn pass trống
DB_NAME=my_database
DB_USER=root
DB_HOST=127.0.0.1

# Load file .env
include .env
export

set-db-pass:
	docker exec -it mariadb-alpine-ncc mariadb -u root -e \
	"ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('$(DB_ROOT_PASSWORD)'); \
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$(DB_ROOT_PASSWORD)' WITH GRANT OPTION; \
	FLUSH PRIVILEGES;"


-- 1. Tạo user mới (Ví dụ tên là 'cong' và mật khẩu là '123')
CREATE USER 'cong'@'%' IDENTIFIED BY '123';

-- 2. Cấp tất cả các quyền trên tất cả database và bảng cho user này
-- 'WITH GRANT OPTION' cho phép user này có thể cấp quyền cho người khác (giống root)
GRANT ALL PRIVILEGES ON *.* TO 'cong'@'%' WITH GRANT OPTION;

-- 3. Làm mới bảng phân quyền để áp dụng ngay lập tức
FLUSH PRIVILEGES;

mariadb-secure-installation

docker exec -it mariadb-alpine-ncc mariadb-secure-installation

printf "\n n \n y \n mật_khẩu_mới \n mật_khẩu_mới \n y \n y \n y \n y \n" | docker exec -i mariadb-alpine-ncc mariadb-secure-installation

# Trả lời 'y' cho mọi câu hỏi
yes y | docker exec -i mariadb-alpine-ncc mariadb-secure-installation

`wp_database`.*

	printf "\n y \n n \n y \n y \n y \n y" | docker exec -i mariadb-alpine-ncc mariadb-secure-installation

    wp_user
    12345

https://0311575875.easyinvoice.com.vn/Account/LogOn?ReturnUrl=%2fEInvoice%2fIndex#

admin

Nhi@12345678

nguyenchicong.catdang@gmail.com
Cong12345@@
0963543681
email khôi phục: sale04.baosonco@gmail.com - Cong12345


curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp