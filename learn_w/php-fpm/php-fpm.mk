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


php-fpm-docker-build:
	@echo "RUN: php-fpm-docker-build"
	$(MAKE) _php-fpm-docker-build
	@echo "DONE: php-fpm-docker-build"

php-fpm-docker-compose:
	@echo "RUN: php-fpm-docker-compose"
	$(MAKE) _php-fpm-docker-compose
	@echo "DONE: php-fpm-docker-compose"

php-fpm-up:
	@echo "RUN: php-fpm-up"
	$(MAKE) php-fpm-docker-build
	@echo "DONE php-fpm-up"


