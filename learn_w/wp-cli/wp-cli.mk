# learn_w/wp-cli/wp-cli.mk

WP_CLI_PROJECT_PATH = $(PROJECT_PATH)/wp-cli
WP_CLI_NAME = wp-cli-alpine-ncc
WP_CLI_URL = https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

include wp-cli/_create-dockerfile.mk

_wp-cli-prepare:
	@echo "_wp-cli-prepare"
	mkdir -p $(WP_CLI_PROJECT_PATH)


wp-cli-up: _wp-cli-prepare
	@echo "wp-cli-up"
	$(MAKE) _wp-cli-create-dockerfile