# learn_w/nginx/_docker-build.mk

include nginx/_create-dockerfile.mk

_nginx-docker-build:
	@echo "RUN: _nginx-docker-build"
	$(MAKE) _nginx-create-dockerfile

	docker build --network host -t $(NGINX_IAMGE) \
		-f $(NGINX_PROJECT_PATH)/Dockerfile \
		$(NGINX_PROJECT_PATH)

	docker images
	@echo "DONE: _nginx-docker-build"