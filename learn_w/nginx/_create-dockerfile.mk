# learn_wlearn_w/nginx/_create-dockerfile.mk

define NGINX_DOCKERFILE
FROM $(ALPINE_IMAGE)
RUN apk update && apk upgrade --no-cache && \
	apk add --no-cache \
		nginx

WORKDIR /var/www/html

RUN chmod +x /run/nginx /var/www/html

CMD ["nginx", "-g", "daemon off;"]
endef

export NGINX_DOCKERFILE

_nginx-create-dockerfile: _nginx-prepare
	@echo "RUN _nginx-create-dockerfile"
	@echo "$$NGINX_DOCKERFILE" > $(NGINX_PROJECT_PATH)/Dockerfile
	@echo "DONE: _nginx-create-dockerfile"