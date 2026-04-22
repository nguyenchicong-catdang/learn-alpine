# learn/makefile/wp-app/_create-docker-compose-yml.mk

define WP_APP_DOCKER_COMPOSE_YML
services:
 $(WP_APP_IMAGE_NAME):
  image: $(WP_APP_IMAGE_NAME)
  container_name: $(WP_APP_IMAGE_NAME)
  init: true
  # network dev
  network_mode: "host"
  env_file:
   - .env
  # CMD => Dockerfile
  command: ["sh", "-c", "tail -f >/dev/null"]
endef

export WP_APP_DOCKER_COMPOSE_YML


_wp-app-create-docker-compose-yml: _wp-app-prepare
	@echo "RUN: _wp-app-create-docker-compose-yml"
	@echo "$$WP_APP_DOCKER_COMPOSE_YML" > $(WP_APP_PROJECT_PATH)/docker-compose.yml
	@echo "DONE: _wp-app-create-docker-compose-yml"