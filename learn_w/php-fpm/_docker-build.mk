# learn_w/php-fpm/_docker-build.mk

include php-fpm/_create-dockerfile.mk

_php-fpm-docker-build:
	@echo "RUN: _php-fpm-docker-build"
	$(MAKE) _php-fpm-create-dockerfile

	docker build --network host -t $(PHP_FPM_IMAGE) \
		-f $(PHP_FPM_PROJECT_PATH)/Dockerfile \
		$(PHP_FPM_PROJECT_PATH)

	@echo "DONE: _php-fpm-docker-build"