# PATH_PROJECT = $(shell dirname $(PWD))/project-test
PATH_PHP = $(PATH_PROJECT)/php
# image name + container name
IMAGE_NAME = 'php-alpine-ncc'
# WORKDIR => WORKDIR /var/www/html ( xu ly ben makecontent - de sau)
WORKDIR_IMAGE = /var/www/html
# php extensions
PHP_EXTENSIONS = php-pdo php-pdo_mysql php-session
# link adminer
ADMINER_URL = https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2-en.php

# DOCKERFILE_CONTENT
include php/dockerfile_content.mk
export DOCKERFILE_CONTENT

php-help:
	@echo "make php-build - build image php"
	@echo "make php-run - run image php"
	@echo "make php-add-extension - add extension php"
	@echo "make php-setup-adminer - Setup adminer"

php-build:
# 	tao thu muc lam viec php
	mkdir -p $(PATH_PHP)
	@echo "tao xong $(PATH_PHP)"
# 	docker file conten
	@echo "$$DOCKERFILE_CONTENT" > $(PATH_PHP)/Dockerfile
	@echo "xong Dockerfile"
# 	docker build - chay tu pwd root makefile => thuc thi file $(PATH_PHP)/Dockerfile . @: thay . =: $(PATH_PHP)
	docker build --network host -t $(IMAGE_NAME) -f $(PATH_PHP)/Dockerfile $(PATH_PHP)
	@echo "xong Docker build"
	docker images

php-run:
	@echo "---RUN IMAGE: $(IMAGE_NAME) ---"
# 	rm -f neu chay lai || true de k thoat loi ton tai
	docker rm -f $(IMAGE_NAME) 2>/dev/null || true
# 	tao thu muc - truong hop built chua tao hoac thay doi
	mkdir -p $(PATH_PHP);
# 	tao thu muc html tai noi chay project
	mkdir -p $(PATH_PHP)/html
# 	phpinfo.php
	echo "<?php phpinfo(); ?>" > $(PATH_PHP)/html/phpinfo.php
# 	docker run
	docker run -d --name $(IMAGE_NAME) \
	--network host \
	-v $(PATH_PHP)/html:/var/www/html \
	$(IMAGE_NAME)

	docker ps

php-add-extension:
	@echo "--- Add extension ---"
	@echo "--- Cai dat tat ca extension cung luc ---"
	docker exec -it $(IMAGE_NAME) sh -c "apk add --no-cache $(PHP_EXTENSIONS)"
	@echo "--- Khoi dong lai container de ap dung thay doi ---"
	docker restart $(IMAGE_NAME)
	@echo "--- Da add: $(PHP_EXTENSIONS) ---"

make php-setup-adminer:
	@echo "--- SETUP ADMINER ---"
# 	add curl
	apk add --no-cache curl
# 	tao thu muc adminer
# 	mkrdir -p $(PATH_PHP)/html/adminer
# 	chui vao bung container
	docker exec -it $(IMAGE_NAME) sh -c "apk add --no-cache curl"
# 	tai file adminer.index
	@echo "--- Dang tai Adminer vao thu muc vua tao ---"
# 	curl -L $(ADMINER_URL) -o $(PATH_PHP)/html/adminer/index.php
# 	chui vao bung container
	docker exec -it $(IMAGE_NAME) sh -c "mkdir -p $(WORKDIR_IMAGE)/adminer && curl -L $(ADMINER_URL) -o $(WORKDIR_IMAGE)/adminer/index.php"
	@echo "---DONE SETUP ADMINER ---"

