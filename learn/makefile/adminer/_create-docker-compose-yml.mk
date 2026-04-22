# learn/makefile/adminer/_create-docker-compose-yml.mk

define ADMINER_DOCKER_COMPOSE_YML
services:
 $(ADMINER_IMAGE):
  image: $(ADMINER_IMAGE)
  container_name: $(ADMINER_IMAGE)
  volumes:
   - $(ADMINER_PATH_APP)/default.conf:/etc/nginx/http.d/default.conf
   - $(ADMINER_PATH_APP)/html:/var/www/html
  init: true
  restart: always
  
  # dev
  #tty: true
  #stdin_open: true
  #ports:
   #- $(ADMINER_EXPOSE):$(ADMINER_EXPOSE)
  network_mode: "host"
endef

export ADMINER_DOCKER_COMPOSE_YML

_adminer-create-docker-compose-yml: _adminer-prepare
	@echo "RUN: _adminer-create-docker-compose-yml"
# 	# 	vloumes /etc/nginx/http.d/default.conf
	cp adminer/default.conf $(ADMINER_PATH_APP)/default.conf

	@echo "$$ADMINER_DOCKER_COMPOSE_YML" > $(ADMINER_PATH_APP)/docker-compose.yml
	@echo "DONE: _adminer-create-docker-compose-yml"