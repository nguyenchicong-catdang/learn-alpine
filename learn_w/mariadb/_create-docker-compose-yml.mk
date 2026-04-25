#learn_w/mariadb/_create-docker-compose-yml.mk

define MARIADB_DOCKER_COMPOSE_YML
services:
 $(MARIADB_NAME):
  image: $(MARIADB_NAME)
  container_name: $(MARIADB_NAME)
  network_mode: "host"
  #init: true
  #command: tail -f >/dev/null
endef

export MARIADB_DOCKER_COMPOSE_YML

_mariadb-create-docker-compose-yml:
	@echo "_mariadb-create-docker-compose-yml"
	@echo "$$MARIADB_DOCKER_COMPOSE_YML" > $(MARIADB_PROJECT_PATH)/docker-compose.yml
