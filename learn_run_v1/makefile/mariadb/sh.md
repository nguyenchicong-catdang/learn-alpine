db-unlock:
	@echo "--- Dang thiet lap Password va mo khoa Remote Access ---"
	docker exec -it mariadb-ncc mariadb -u root -e "\
		ALTER USER 'root'@'localhost' IDENTIFIED BY '123456'; \
		CREATE USER 'root'@'%' IDENTIFIED BY '123456'; \
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; \
		FLUSH PRIVILEGES;"

SELECT User, Host, Password, plugin FROM mysql.user;

netstat -tulpn | grep 3306

-- 1. Tạo user root cho phép kết nối từ mọi nơi (%)
CREATE USER 'root'@'%' IDENTIFIED BY '123456';

-- 2. Cấp toàn quyền cho user này
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- 3. Lưu lại thiết lập
FLUSH PRIVILEGES;

docker exec -it $(IMAGE_NAME) mariadb -u root -e "\
		CREATE USER IF NOT EXISTS 'test'@'%' IDENTIFIED BY '123456'; \
		GRANT ALL PRIVILEGES ON *.* TO 'test'@'%' WITH GRANT OPTION; \
		FLUSH PRIVILEGES;"

-- 1. Đảm bảo user 'test' có thể vào từ IP loopback (127.0.0.1)
CREATE USER IF NOT EXISTS 'test'@'127.0.0.1' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON *.* TO 'test'@'127.0.0.1' WITH GRANT OPTION;

-- 2. Đảm bảo user 'test' có thể vào từ bất cứ đâu (%)
-- Đôi khi Docker Network nhận diện IP của container PHP là một dải IP khác
GRANT ALL PRIVILEGES ON *.* TO 'test'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;

-- 3. Quan trọng nhất: Nạp lại bảng quyền
FLUSH PRIVILEGES;


docker exec -it $(IMAGE_NAME) mariadb -u root -e "\
		CREATE USER IF NOT EXISTS 'test'@'%' IDENTIFIED BY '123456'; \
		GRANT ALL PRIVILEGES ON *.* TO 'test'@'127.0.0.1' WITH GRANT OPTION; \
		FLUSH PRIVILEGES;"

# done
mariadb-create-user:
# 	# chui vao bung
	@echo "--- CREATE USER test ---"
	docker exec -it $(IMAGE_NAME) mariadb -u root -e "\
		CREATE USER IF NOT EXISTS 'test'@'127.0.0.1' IDENTIFIED BY '123456'; \
		GRANT ALL PRIVILEGES ON *.* TO 'test'@'127.0.0.1' WITH GRANT OPTION; \
		GRANT ALL PRIVILEGES ON *.* TO 'test'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION; \
		FLUSH PRIVILEGES;"

	@echo "--- DONE ---"

# chui vafo bujng chay 
> mariadb-secure-installation

> adminer > 127.0.0.1 > test > 123456