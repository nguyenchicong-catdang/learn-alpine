# learn_w/nginx/nginx.mk

# VAR
NGINX_IAMGE = nginx-apine-ncc
NGINX_PROJECT_PATH = $(PROJECT_PATH)/nginx

include nginx/_docker-build.mk
include nginx/_docker-compose.mk

nginx-help:
	@echo "make nginx-help"
	@echo "make nginx-up"
	@echo "make nginx-docker-build"
	@echo "make nginx-docker-compose-up"
	@echo "make nginx-docker-compose-down"

_nginx-prepare:
	mkdir -p $(NGINX_PROJECT_PATH)
	cp -f ./nginx/default.conf $(NGINX_PROJECT_PATH)
	cp -r ./nginx/html $(NGINX_PROJECT_PATH)


nginx-docker-build:
	@echo "RUN: nginx-docker-build"
	$(MAKE) _nginx-docker-build
	@echo "DONE: nginx-docker-build"

nginx-docker-compose-up:
	@echo "RUN: nginx-docker-compose-up"
	$(MAKE) _nginx-docker-compose-up
	@echo "DONE: nginx-docker-compose-up"

nginx-docker-compose-down:
	@echo "RUN: nginx-docker-compose-down"
	$(MAKE) _nginx-docker-compose-down
	@echo "DONE: nginx-docker-compose-down"

nginx-up:
	@echo "RUN: nginx-up"
	$(MAKE) nginx-docker-build
	$(MAKE) nginx-docker-compose-up
	@echo "DONE: nginx-up"

nginx-down:
	@echo "RUN: nginx-down"
	$(MAKE) _nginx-docker-compose-down-v
	@echo "DONE: nginx-down"

nginx-down-v:
	@echo "RUN: nginx-down-v"
	$(MAKE) _nginx-docker-compose-down-v
	@echo "DONE: nginx-down-v"