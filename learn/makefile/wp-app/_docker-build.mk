# learn/makefile/wp-app/_docker-build.mk

include wp-app/_create-dockerfile.mk

_wp-app-docker-build:
	@echo "RUN: _wp-app-docker-build"
	$(MAKE) _wp-app-create-dockerfile

	docker build --network host -t $(WP_APP_IMAGE_NAME) -f $(WP_APP_PROJECT_PATH)/Dockerfile $(WP_APP_PROJECT_PATH)

	docker images
	@echo "DONE: _wp-app-docker-build"