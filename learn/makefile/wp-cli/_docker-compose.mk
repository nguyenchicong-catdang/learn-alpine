# learn/makefile/wp-cli/_docker-compose.mk

include wp-cli/_create-docker-compose-yml.mk

_wp-cli-docker-compose-up:
	@echo "RUN: _wp-cli-docker-compose-up"
	$(MAKE) _wp-cli-create-docker-compose-yml

	docker compose -f $(WP_CLI_PROJECT_PATH)/docker-compose.yml --project-directory $(WP_CLI_PROJECT_PATH) up -d

	docker ps
	@echo "DONE: _wp-cli-docker-compose-up"

_wp-cli-docker-compose-down:
	@echo "RUN: _wp-cli-docker-compose-down"
	docker compose -f $(WP_CLI_PROJECT_PATH)/docker-compose.yml down

	docker ps
	@echo "DONE: _wp-cli-docker-compose-down"