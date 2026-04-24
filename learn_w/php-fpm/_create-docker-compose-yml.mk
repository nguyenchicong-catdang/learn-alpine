# learn_w/php-fpm/_create-docker-compose-yml.mk

define PHP_FPM_DOCKER_COMPOSE_YML
services:
 $(PHP_FPM_IMAGE):
  image: $(PHP_FPM_IMAGE)
  container_name: $(PHP_FPM_IMAGE)
  network_mode: "host"
  command: tail -f /def/null
endef

export PHP_FPM_DOCKER_COMPOSE_YML
_php-fpm-create-docker-compose-yml: _php-fpm-prepare
	@echo "RUN: _php-fpm-create-docker-compose-yml"
	@echo "$$PHP_FPM_DOCKER_COMPOSE_YML" > $(PHP_FPM_PROJECT_PATH)/docker-compose.yml
	@echo "DONE: _php-fpm-create-docker-compose-yml"