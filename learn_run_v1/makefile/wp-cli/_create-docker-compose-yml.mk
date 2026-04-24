# learn/makefile/wp-cli/_create-docker-compose-yml.mk

define WP_CLI_DOCKER_COMPOSE_YML
services:
 $(WP_CLI_IMAGE_NAME):
  image: $(WP_CLI_IMAGE_NAME)
  container_name: $(WP_CLI_IMAGE_NAME)
  init: true
  network_mode: "host"
  env_file:
   - .env
  #entrypoint: ["/bin/sh", "-c", "tail -f /dev/null"]
  command: tail -f /dev/null
endef

export WP_CLI_DOCKER_COMPOSE_YML

_wp-cli-create-docker-compose-yml: _wp-cli-prepare
	@echo "RUN: _wp-cli-create-docker-compose-yml"
	@echo "$$WP_CLI_DOCKER_COMPOSE_YML" > $(WP_CLI_PROJECT_PATH)/docker-compose.yml
	@echo "DONE: _wp-cli-create-docker-compose-yml"