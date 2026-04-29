--unix-socket[=name]

-u, --user=name     Run mysqld daemon as user.
  --user-variables[=name] 
                      Enable or disable user_variables plugin. One of: ON, OFF,
                      FORCE (don't start if the plugin fails to load),
                      FORCE_PLUS_PERMANENT (like FORCE, but the plugin can not
                      be uninstalled).

console  FALSE

/usr/bin/mariadbd-safe --datadir='/var/lib/mysql

/usr/bin/mariadbd-safe --datadir='/var/lib/mysql' &

/usr/bin/

/usr/bin/mariadbd-safe --datadir='/var/lib/mysql' --user=mysql &

ps aux | grep mariadb

mysql -u root


ps aux | grep mariadb
  109 root      0:00 {mariadbd-safe} /bin/sh /usr/bin/mariadbd-safe --datadir=/var/lib/mysql
  181 mysql     0:01 /usr/bin/mariadbd --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mariadb/plugin --user=mysql --log-error=/var/lib/mysql/DESKTOP-EN5O26C.err --pid-file=DESKTOP-EN5O26C.pid
  247 root      0:00 grep mariadb

# Giết tất cả tiến trình có tên mariadbd và mysqld_safe
pkill -9 mariadbd
pkill -9 mysqld_safe

kill -9 181

/usr/bin/mysqladmin -u root shutdown

my.cnf

/usr/bin/mariadbd-safe --datadir='/var/lib/mysql' --user=mysql > /dev/null 2>&1 &

# 1. Khởi động MariaDB tạm thời dưới dạng chạy ngầm để cấu hình
echo "Starting MariaDB temporarily for configuration..."
/usr/bin/mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking &
pid="$!"

# 2. Chờ cho đến khi MariaDB thực sự sẵn sàng
# Kiểm tra bằng lệnh mysqladmin ping
until mysqladmin ping >/dev/null 2>&1; do
  echo "Waiting for MariaDB to start..."
  sleep 1
done

# 3. Chạy các lệnh thiết lập bảo mật (không dùng docker exec vì ta đang ở TRONG container rồi)
echo "Running secure installation..."
printf "\ny\nn\ny\ny\ny\ny\n" | mariadb-secure-installation

# 4. Tắt server tạm thời để trả lại quyền cho lệnh exec chính thức
echo "Shutting down temporary server..."
mysqladmin -u root shutdown

# 5. Cuối cùng mới gọi exec để chạy MariaDB ở chế độ chính thức (foreground)
echo "Starting MariaDB officially..."
exec "$@"


healthcheck:
      test: ["CMD", "mariadb-admin", "ping", "-h", "localhost", "--silent"]
      interval: 10s      # Cứ mỗi 10 giây kiểm tra 1 lần
      timeout: 5s       # Chờ phản hồi tối đa 5 giây
      retries: 5        # Thử lại 5 lần, nếu lỗi cả 5 thì đánh dấu là "unhealthy"
      start_period: 30s # Cho phép database có 30 giây để khởi động trước khi bắt đầu check

docker ps

docker inspect --format='{{json .State.Health.Status}}' $(MARIADB_NAME)

services:
  app-laravel:
    depends_on:
      $(MARIADB_NAME):
        condition: service_healthy

check-health:
	docker ps --filter "name=$(MARIADB_NAME)" --format "{{.Names}}: {{.Status}}"
_mariadb-create-user:
	@echo "Waiting for MariaDB to be healthy..."
	@# Vòng lặp đợi cho đến khi status là "healthy"
	@until [ "$$(docker inspect --format='{{.State.Health.Status}}' mariadb-alpine-ncc)" = "healthy" ]; do \
		echo "Still starting... (health: starting)"; \
		sleep 1; \
	done
	@echo "MariaDB is healthy! Running setup..."
	
	@# Sử dụng -i nhưng BỎ -t để tránh lỗi stty
	printf "\ny\nn\ny\ny\ny\ny\n" | docker exec -i mariadb-alpine-ncc mariadb-secure-installation
	
	@# Tương tự, dùng -i (không dùng -t) cho các lệnh truyền qua pipe/Makefile
	docker exec -i mariadb-alpine-ncc mariadb -u root -e \
		"CREATE USER IF NOT EXISTS '$(DB_USER)'@'$(DB_HOST)' IDENTIFIED BY '$(DB_PASSWORD)'; \
		GRANT ALL PRIVILEGES ON *.* TO '$(DB_USER)'@'$(DB_HOST)' WITH GRANT OPTION; \
		FLUSH PRIVILEGES;"

docker exec -i mariadb-alpine-ncc mariadb -u root -e "SELECT User, Host FROM mysql.user;"