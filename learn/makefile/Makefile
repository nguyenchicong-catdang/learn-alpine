# /home/git/learn-alpine/learn/makefile/Makefile
# Định nghĩa biến gốc
PATH_PROJECT = $(shell dirname $(PWD))/project-test
IMAGE_ALPINE = alpine:3.23.3
# include
# nginx alpine cus ncc
include nginx/nginx.mk
# php alpine cus ncc
include php/php.mk

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


pull-alpine:
	docker pull $(IMAGE_ALPINE)