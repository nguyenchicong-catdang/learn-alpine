# learn_w/wp-cli/wp-cli.mk

WP_CLI_PROJECT_PATH = $(PROJECT_PATH)/wp-cli
WP_CLI_NAME = wp-cli-alpine-ncc
WP_CLI_URL = https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

include wp-cli/_create-user.mk
include wp-cli/_create-dockerfile.mk
include wp-cli/_docker-build.mk
include wp-cli/_docker-cp.mk

_wp-cli-prepare:
	@echo "_wp-cli-prepare"
	mkdir -p $(WP_CLI_PROJECT_PATH)
	cp -f ./wp-cli/.env $(WP_CLI_PROJECT_PATH)/.env
	cp -f ./wp-cli/wp-config.php $(WP_CLI_PROJECT_PATH)/wp-config.php
	cp -f ./wp-cli/wp-cli.sh $(WP_CLI_PROJECT_PATH)/wp-cli.sh


wp-cli-up: _wp-cli-prepare
	@echo "wp-cli-up"
	$(MAKE) _wp-cli-create-user
	$(MAKE) _wp-cli-create-dockerfile
	$(MAKE) _wp-cli-docker-build
	$(MAKE) _wp-cli-docker-cp.mk