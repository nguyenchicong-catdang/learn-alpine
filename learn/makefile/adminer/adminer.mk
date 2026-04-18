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

