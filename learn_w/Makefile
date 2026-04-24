# cd /home/git/learn-alpine/learn_w
# learn_w/Makefile

.DEFAULT_GOAL :=help

# VAR
ALPINE_IMAGE = alpine:3
PROJECT_DIR = $(shell dirname $(PWD))
PROJECT_PATH = $(PROJECT_DIR)/learn-project

# include
include nginx/nginx.mk
include php-fpm/php-fpm.mk

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
	@echo "DONE: up"

down:
	@echo "RUN: down"
	$(MAKE) nginx-down
	@echo "DONE: down"