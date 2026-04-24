# learn_w/nginx/_create-docker-compose-yml.mk

define NGINX_DOCKER_COMPOSE_YML
services:
 $(NGINX_IAMGE):
  image: $(NGINX_IAMGE)
  container_name: $(NGINX_IAMGE)
  #init: true
  network_mode: "host"
  volumes:
   - ./default.conf:/etc/nginx/http.d/default.conf
   - ./html:/var/www/html
  #command: tail -f >/dev/null
endef

export NGINX_DOCKER_COMPOSE_YML

_nginx-create-docker-compose-yml: _nginx-prepare
	@echo "RUN: _nginx-create-docker-compose-yml"
	@echo "$$NGINX_DOCKER_COMPOSE_YML" > $(NGINX_PROJECT_PATH)/docker-compose.yml
	@echo "DONE: _nginx-create-docker-compose-yml"