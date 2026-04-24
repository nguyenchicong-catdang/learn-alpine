# https://wiki.alpinelinux.org/wiki/MariaDB
# PATH_PROJECT = $(shell dirname $(PWD))/project-test
PATH_MARIADB = $(PATH_PROJECT)/mariadb
# image name + container name
IMAGE_NAME = 'mariadb-alpine-ncc'
# WORKDIR => WORKDIR /var/www/html ( xu ly ben makecontent - de sau)
WORKDIR_IMAGE = /var/lib/mysql
# dockerfile content
include mariadb/dockerfile_content.mk
export DOCKERFILE_CONTENT

mariadb-help:
	@echo "make mariadb-build - build image mariadb"
	@echo "make mariadb-run - run image mariadb"
	@echo "mariadb-create-user - create user test"
mariadb-build:
	@echo "--- BUILD ---"
# 	tao thu muc lam viec mariadb
	mkdir -p $(PATH_MARIADB)
	@echo " -> Tao xong: $(PATH_MARIADB)"
# 	tao dockerfile
	@echo "$$DOCKERFILE_CONTENT" > $(PATH_MARIADB)/Dockerfile
	@echo "-> Xong Dockerfile!"
# 	built
	docker build --network host -t $(IMAGE_NAME) -f $(PATH_MARIADB)/Dockerfile $(PATH_MARIADB)
	docker images

mariadb-run:
	@echo "--- RUN $(IMAGE_NAME) ---"
	@docker rm -f $(IMAGE_NAME) 2>/dev/null || true
# 	# BƯỚC 1: Phải tạo file trước
	@mkdir -p $(PATH_MARIADB)
# 	# run
	docker run -d --name $(IMAGE_NAME) \
		--network host \
		$(IMAGE_NAME)

	docker ps

mariadb-create-user:
# 	# chui vao bung
	@echo "--- CREATE USER test ---"
	docker exec -it $(IMAGE_NAME) mariadb -u root -e "\
		CREATE USER IF NOT EXISTS 'test'@'127.0.0.1' IDENTIFIED BY '123456'; \
		GRANT ALL PRIVILEGES ON *.* TO 'test'@'127.0.0.1' WITH GRANT OPTION; \
		GRANT ALL PRIVILEGES ON *.* TO 'test'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION; \
		FLUSH PRIVILEGES;"

	@echo "--- DONE ---"

mariadb-down:
	docker rm -f $(IMAGE_NAME) 2>/dev/null || true