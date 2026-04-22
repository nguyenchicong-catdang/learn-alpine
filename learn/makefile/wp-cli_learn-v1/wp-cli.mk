# PATH_PROJECT = $(shell dirname $(PWD))/project-test
PATH_WP_CLI = $(PATH_PROJECT)/wp-cli
WP_CLI_PROJECT_PATH = $(PROJECT_PATH)/wp-cli
IMAGE_NAME = 'wp-cli-alpine-ncc'
WP_CLI_IMAHE_NAME = wp-cli-alpine-ncc
# WORKDIR => WORKDIR /var/www/html ( xu ly ben makecontent - de sau)
WORKDIR_IMAGE = /var/www/html
# php extensions
PHP_EXTENSIONS = php-mysqli

# DOCKERFILE_CONTENT
include wp-cli/dockerfile_content.mk
export DOCKERFILE_CONTENT

wp-cli-help:
	@echo "make wp-cli-build - Build image wp-cli"
	@echo "make wp-cli-run - Run image wp-cli"

wp-cli-build:
	@echo "-> BUILD"
# 	# tao thu muc lam viec php
	mkdir -p $(WP_CLI_PROJECT_PATH)
	@echo "tao xong $(WP_CLI_PROJECT_PATH)"
# 	docker file conten
	@echo "$$DOCKERFILE_CONTENT" > $(WP_CLI_PROJECT_PATH)/Dockerfile
	@echo "xong Dockerfile"
# 	docker build - chay tu pwd root makefile => thuc thi file $(PATH_PHP)/Dockerfile . @: thay . =: $(PATH_PHP)
	docker build --network host -t $(WP_CLI_IMAHE_NAME) -f $(WP_CLI_PROJECT_PATH)/Dockerfile $(WP_CLI_PROJECT_PATH)
	@echo "xong Docker build"
	docker images

wp-cli-run:
	@echo "---RUN IMAGE: $(WP_CLI_IMAHE_NAME) ---"
# 	rm -f neu chay lai || true de k thoat loi ton tai
	docker rm -f $(WP_CLI_IMAHE_NAME) 2>/dev/null || true
# 	tao thu muc - truong hop built chua tao hoac thay doi
# 	mkdir -p $(PATH_WP_CLI);
# 	tao thu muc html tai noi chay project
# 	mkdir -p $(PATH_WP_CLI)/html
# 	phpinfo.php
# 	echo "<?php phpinfo(); ?>" > $(PATH_WP_CLI)/html/phpinfo.php
# 	docker run
	docker run -d --name $(WP_CLI_IMAHE_NAME) \
	--network host \
	$(WP_CLI_IMAHE_NAME)

	docker ps