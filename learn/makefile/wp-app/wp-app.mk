# learn/makefile/wp-app/wp-app.mk

WP_APP_PROJECT_PATH = $(PROJECT_PATH)/wp-app
WP_APP_IMAGE_NAME = wp-app-alpine-ncc

include wp-app/_docker-build.mk
include wp-app/_docker-compose.mk

wp-app-help:
	@echo "make wp-app-docker-build"
	@echo "make wp-app-up"

_wp-app-prepare:
	@echo "RUN: _wp-app-prepare"
	mkdir -p $(WP_APP_PROJECT_PATH)
# 	# check build WP_CLI_IMAHE_NAME
	if [ -n "$(WP_CLI_IMAGE_NAME)" ]; then \
		if [ -z "$$(docker images -q $(WP_CLI_IMAGE_NAME) 2>/dev/null)" ]; then \
			echo "IMAGE: $(WP_CLI_IMAGE_NAME) khong ton tai"; \
		else \
			echo "IMAGE: $(WP_CLI_IMAGE_NAME) da ton tai"; \
		fi \
	else \
		echo "VAR: khong ton tai vui long kiem tra lai code"; \
	fi

	cp -f wp-app/wp-config.php $(WP_APP_PROJECT_PATH)/wp-config.php

	@echo "DONE: _wp-app-prepare"

wp-app-docker-build:
	@echo "RUN: wp-app-docker-build"
	$(MAKE) _wp-app-docker-build
	@echo "DONE: wp-app-docker-build"

wp-app-docker-compose-up:
	@echo "RUN: wp-app-docker-compose-up"
	$(MAKE) _wp-app-docker-compose-up
	@echo "DONE: wp-app-docker-compose-up"

wp-app-docker-compose-down:
	@echo "RUN: wp-app-docker-compose-down"
	$(MAKE) _wp-app-docker-compose-down
	@echo "DONE: wp-app-docker-compose-down"

wp-app-up:
	@echo "RUN: wp-app-up"
	$(MAKE) wp-app-docker-build
	$(MAKE) wp-app-docker-compose-up
	@echo "RUN: wp-app-up"