# learn_w/php-fpm/_create-dockerfile.mk

define PHP_FPM_DOCKERFILE
FROM $(ALPINE_IMAGE)

RUN apk update && apk upgrade --no-cache && \
	apk add --no-cache \
		php84-fpm \

CMD ["php84-fpm", "-D", "-R"]
endef

export PHP_FPM_DOCKERFILE

_php-fpm-create-dockerfile: _php-fpm-prepare
	@echo "RUN: _php-fpm-create-dockerfile"
	@echo "$$PHP_FPM_DOCKERFILE" > $(PHP_FPM_PROJECT_PATH)/Dockerfile
	@echo "DONE: _php-fpm-create-dockerfile"