# learn/makefile/wp-cli/wp-cli.mk

WP_CLI_PROJECT_PATH = $(PROJECT_PATH)/wp-cli
WP_CLI_IMAGE_NAME = wp-cli-alpine-ncc

include wp-cli/_docker-build.mk

include wp-cli/_docker-compose.mk

wp-cli-help:
	@echo "make wp-cli-docker-build"

_wp-cli-prepare:
	@echo "RUN: _wp-cli-prepare"
	mkdir -p $(WP_CLI_PROJECT_PATH)
	cp -f wp-cli/.env $(WP_CLI_PROJECT_PATH)/.env
	cp -f wp-cli/wp-cli.sh $(WP_CLI_PROJECT_PATH)/wp-cli.sh
	cp -f wp-cli/wp-config.php $(WP_CLI_PROJECT_PATH)/wp-config.php
	@echo "DONE: _wp-cli-prepare"

wp-cli-docker-build:
	@echo "RUN: wp-docker-build"
	$(MAKE) _wp-cli-docker-build
	@echo "DONE: wp-docker-build"

wp-cli-docker-compose-up:
	@echo "RUN: wp-cli-docker-compose-up"
	$(MAKE) _wp-cli-docker-compose-up
	@echo "DONE: wp-cli-docker-compose-up"

wp-cli-docker-compose-down:
	@echo "RUN: wp-cli-docker-compose-down"
	$(MAKE) _wp-cli-docker-compose-down
	@echo "DONE: wp-cli-docker-compose-down"


wp-cli-up:
	@echo "RUN: wp-cli-up"
	$(MAKE) wp-cli-docker-build
	$(MAKE) wp-cli-docker-compose-up
	@echo "DONE: wp-cli-up"