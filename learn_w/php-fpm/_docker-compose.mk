# learn_w/php-fpm/_docker-compose.mk

include php-fpm/_create-docker-compose-yml.mk

_php-fpm-docker-compose-create-yml:
	@echo "RUN: _php-fpm-docker-compose"
	$(MAKE) _php-fpm-create-docker-compose-yml
	@echo "DONE: _php-fpm-docker-compose"

_php-fpm-docker-compose-up:
	@echo "_php-fpm-docker-compose-up"
	$(MAKE) _php-fpm-docker-compose-create-yml

	docker compose -f $(PHP_FPM_PROJECT_PATH)/docker-compose.yml \
		--project-directory $(PHP_FPM_PROJECT_PATH) up -d

_php-fpm-docker-compose-down:
	@echo "_php-fpm-docker-compose-down"
	docker compose -f $(PHP_FPM_PROJECT_PATH)/docker-compose.yml down

_php-fpm-docker-compose-down-v:
	@echo "_php-fpm-docker-compose-down-v"
	docker compose -f $(PHP_FPM_PROJECT_PATH)/docker-compose.yml down -v