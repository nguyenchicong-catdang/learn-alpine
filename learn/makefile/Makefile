# /home/git/learn-alpine/learn/makefile/Makefile
# Định nghĩa biến gốc
PATH_PROJECT = $(shell dirname $(PWD))/project-test
IMAGE_ALPINE = alpine:3.23.3
APP_ENV = development

# include
# nginx alpine cus ncc
include nginx/nginx.mk
# php alpine cus ncc
include php/php.mk
# mariadb alpine cus ncc
include mariadb/mariadb.mk
# wp-cli alpine cus ncc
include wp-cli/wp-cli.mk
# laravel-app
include laravel-app/laravel-app.mk
# adminer
include adminer/adminer.mk

# Mặc định khi gõ 'make' sẽ hiện hướng dẫn
.DEFAULT_GOAL :=help
help:
	@echo "--- Cac lenh ho tro ---"
# 	pull image alpine:3.23.3
	@echo "make pull-alpine - Pull image alpine 3.23.23"
# 	nginx alpine cus ncc
	@echo "make nginx-help - Nginx Help"
# 	php alpine cus ncc
	@echo "make php-help - Php help"
# 	php alpine cus ncc
	@echo "make mariadb-help - Mariadb help"
# 	wp-cli
	@echo "make wp-cli-help - wp-cli help"
# 	laravel-app
	@echo "make laravel-app-help - Laravel App help"
# 	adminer
	@echo "make adminer-help - Help adminer"

pull-alpine:
	docker pull $(IMAGE_ALPINE)