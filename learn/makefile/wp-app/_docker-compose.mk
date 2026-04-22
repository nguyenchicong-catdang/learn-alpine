# learn/makefile/wp-app/_docker-compose.mk

include wp-app/_create-docker-compose-yml.mk

_wp-app-docker-compose-up:
	@echo "RUN: _wp-app-docker-compose"
	$(MAKE) _wp-app-create-docker-compose-yml

	docker compose -f $(WP_APP_PROJECT_PATH)/docker-compose.yml --project-directory $(WP_APP_PROJECT_PATH) up -d

	docker ps
	@echo "DONE: _wp-app-docker-compose"

_wp-app-docker-compose-down:
	@echo "RUN: _wp-app-docker-compose-down"
	docker compose -f $(WP_APP_PROJECT_PATH)/docker-compose.yml down
	@echo "DONE: _wp-app-docker-compose-down"