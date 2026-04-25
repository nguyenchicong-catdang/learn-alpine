# learn_w/php-fpm/php-fpm.mk

PHP_FPM_PROJECT_PATH = $(PROJECT_PATH)/php-fpm
PHP_FPM_IMAGE = php-fpm-alpine-ncc

include php-fpm/_docker-build.mk
include php-fpm/_docker-compose.mk

php-fpm-help:
	@echo "make php-fpm-help"

_php-fpm-prepare:
	@echo "RUN: _php-fpm-prepare"
	mkdir -p $(PHP_FPM_PROJECT_PATH)
	@echo "DONE: _php-fpm-prepare"

php-fpm-up: _php-fpm-prepare
	@echo "RUN: php-fpm-up"
	$(MAKE) _php-fpm-docker-build
	$(MAKE) _php-fpm-docker-compose-up
	@echo "DONE php-fpm-up"

php-fpm-down:
	@echo "php-fpm-down"
	$(MAKE) _php-fpm-docker-compose-down


