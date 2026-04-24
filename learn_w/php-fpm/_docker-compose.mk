# learn_w/php-fpm/_docker-compose.mk

include php-fpm/_create-docker-compose-yml.mk

_php-fpm-docker-compose:
	@echo "RUN: _php-fpm-docker-compose"
	$(MAKE) _php-fpm-create-docker-compose-yml
	@echo "DONE: _php-fpm-docker-compose"