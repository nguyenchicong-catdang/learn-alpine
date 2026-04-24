# learn/makefile/adminer/adminer.mk

# PATH_PROJECT = $(shell dirname $(PWD))/project-test
ADMINER_PATH_APP := $(PATH_PROJECT)/adminer
# WORKDIR
ADMINER_WORKDIR := /var/www/html
# EXPOSE
ADMINER_EXPOSE := 3366
# image name + container name
ADMINER_IMAGE := admine-alpine-ncc
# create-dockerfile
include adminer/_docker-build.mk
# docker-run
include adminer/_docker-run.mk
# docker compse
include adminer/_docker-compose.mk

adminer-help:
	@echo "make adminer-docker-build - adminer-docker-build"
	@echo "make adminer-docker-run-dev - adminer-docker-run-dev"

adminer-docker-build:
	@echo "BUILD"
# 	adminer/docker-build
	$(MAKE) adminer-docker-build-init
	@echo "DONE BUILD"

adminer-docker-run:
	@echo "make adminer-docker-run-dev - adminer-docker-run-dev"

_adminer-prepare:
	mkdir -p $(ADMINER_PATH_APP)
	mkdir -p $(ADMINER_PATH_APP)/html
# 	download https://www.adminer.org/static/download/5.4.2/editor-5.4.2-en.php
# 	curl -L https://www.adminer.org/static/download/5.4.2/editor-5.4.2-en.php -o index.php
	@if [ ! -f $(ADMINER_PATH_APP)/html/index.php ]; then \
		echo "Downloading Adminer Editor..."; \
		curl -L https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2-en.php -o $(ADMINER_PATH_APP)/html/index.php; \
	else \
		echo "Adminer already exists, skipping download."; \
	fi

adminer-up: _adminer-prepare
	@echo "RUN: adminer-up"
	$(MAKE) adminer-docker-build
	$(MAKE) _adminer-docker-compose-up
	@echo "DONE: adminer-up"

adminer-down:
	$(MAKE) _adminer-docker-compose-down


