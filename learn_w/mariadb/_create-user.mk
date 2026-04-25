# learn_w/mariadb/_create-user.mk

include mariadb/.env

_mariadb-create-user:
	@echo "_mariadb-create-user"
	@sleep 2
	docker exec -it mariadb-alpine-ncc mariadb -u root -e \
		"CREATE USER IF NOT EXISTS '$(DB_USER)'@'$(DB_HOST)' IDENTIFIED BY '$(DB_PASSWORD)'; \
		GRANT ALL PRIVILEGES ON *.* TO '$(DB_USER)'@'$(DB_HOST)' WITH GRANT OPTION; \
		FLUSH PRIVILEGES;"
	
	@sleep 2
# 	yes y | docker exec -i mariadb-alpine-ncc mariadb-secure-installation
# 	# Enter (mật khẩu trống), sau đó là 'n' cho unix_socket, rồi 'y' cho các bước sau
# 	# printf "\n n \n y \n pass \n pass \n y \n y \n y \n y \n" | docker exec -i mariadb-alpine-ncc mariadb-secure-installation
	printf "\n y \n n \n y \n y \n y \n y" | docker exec -i mariadb-alpine-ncc mariadb-secure-installation