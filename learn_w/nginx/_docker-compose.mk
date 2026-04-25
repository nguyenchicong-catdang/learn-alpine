# learn_w/nginx/_docker-compose.mk

include nginx/_create-docker-compose-yml.mk

_nginx-docker-compose-up:
	@echo "RUN: _nginx-docker-compose"
	$(MAKE) _nginx-create-docker-compose-yml

	docker compose -f $(NGINX_PROJECT_PATH)/docker-compose.yml \
		--project-directory $(NGINX_PROJECT_PATH) \
		up -d \
		
	@echo "DONE: _nginx-docker-compose"

_nginx-docker-compose-down:
	@echo "RUN: _nginx-docker-compose-down"
	docker compose -f $(NGINX_PROJECT_PATH)/docker-compose.yml down
	@echo "DONE: _nginx-docker-compose-down"