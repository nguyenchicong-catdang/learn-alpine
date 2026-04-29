# cd /home/git/learn-alpine/learn_w
# learn_w/Makefile

.DEFAULT_GOAL :=help

# VAR
ALPINE_IMAGE = alpine:3
PROJECT_DIR = $(shell dirname $(PWD))
PROJECT_PATH = $(PROJECT_DIR)/learn-project
NGINX_VOLUMES_HTML =  ../nginx/html
NGINX_CP_HTML = $(NGINX_PROJECT_PATH)/html

# include
include nginx/nginx.mk
include php-fpm/php-fpm.mk
include adminer/adminer.mk
include mariadb/mariadb.mk
include wp-cli/wp-cli.mk

help:
	@echo "make help"
	@echo "make nginx-help"
	@echo "make php-fpm-help"

prepare:
	@echo "RUN: prepare"
	mkdir -p $(PROJECT_PATH)
	@echo "DONE: prepare"

pull-alpine-image:
	@echo "RUN: pull-alpine-image"
	docker pull $(ALPINE_IMAGE)
	@echo "DONE: pull-alpine-image"

up: prepare
	@echo "RUN: up"
	$(MAKE) pull-alpine-image
# 	include up
	$(MAKE) nginx-up
	$(MAKE) php-fpm-up
	$(MAKE) adminer-up
	$(MAKE) mariadb-up
	$(MAKE) wp-cli-up

	docker ps
	@echo "DONE: up"

down:
	@echo "RUN: down"
	$(MAKE) nginx-down
	$(MAKE) php-fpm-down
	$(MAKE) mariadb-down
	@echo "DONE: down"

down-v:
	@echo "RUN: down-v"
	$(MAKE) nginx-down
	$(MAKE) php-fpm-down
	$(MAKE) mariadb-down-v
	@echo "DONE: down-v"