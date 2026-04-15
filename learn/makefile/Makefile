# /home/git/learn-alpine/learn/makefile/Makefile
# Định nghĩa biến gốc
PATH_PROJECT = $(shell dirname $(PWD))/project-test
IMAGE_ALPINE = alpine:3.23.3
# include
include nginx/nginx.mk
# Mặc định khi gõ 'make' sẽ hiện hướng dẫn
.DEFAULT_GOAL :=help
help:
	@echo "Cac lenh ho tro"
	@echo "make pull-alpine - Pull image alpine 3.23.23"
	@echo "make nginx-help - Nginx Help"

pull-alpine:
	docker pull $(IMAGE_ALPINE)