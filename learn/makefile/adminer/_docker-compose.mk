# learn/makefile/adminer/_docker-compose.mk


include adminer/_create-docker-compose-yml.mk

_adminer-docker-compose-up:
	@echo "RUN: _adminer-docker-compose-up"

	$(MAKE) _adminer-create-docker-compose-yml

	docker compose -f $(ADMINER_PATH_APP)/docker-compose.yml --project-directory $(ADMINER_PATH_APP) up -d

	docker ps
	@echo "DONE: _adminer-docker-compose-up"

_adminer-docker-compose-down:
	@echo "RUN: _adminer-docker-compose-down"
	docker compose -f $(ADMINER_PATH_APP)/docker-compose.yml down

	docker ps
	@echo 'DONE: _adminer-docker-compose-down'