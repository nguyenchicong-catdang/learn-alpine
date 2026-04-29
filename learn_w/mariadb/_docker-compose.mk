# learn_w/mariadb/_docker-compose.mk

_mariadb-docker-compose-up:
	@echo "_mariadb-docker-compose-up"
	docker compose -f $(MARIADB_PROJECT_PATH)/docker-compose.yml \
		--project-directory $(MARIADB_PROJECT_PATH) up -d

_mariadb-docker-compose-down:
	@echo "_mariadb-docker-compose-down"
	docker compose -f $(MARIADB_PROJECT_PATH)/docker-compose.yml down

_mariadb-docker-compose-down-v:
	@echo "_mariadb-docker-compose-down-v"
	docker compose -f $(MARIADB_PROJECT_PATH)/docker-compose.yml down -v