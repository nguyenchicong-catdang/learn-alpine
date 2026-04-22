# learn/makefile/wp-cli/_docker-build.mk

include wp-cli/_create-dockerfile.mk

_wp-cli-docker-build:
	@echo "RUN: _wp-cli-docker-build"
	$(MAKE) _wp-cli-create-dockerfile

	docker build --network host -t $(WP_CLI_IMAGE_NAME) -f $(WP_CLI_PROJECT_PATH)/Dockerfile $(WP_CLI_PROJECT_PATH)

	docker images
	@echo "DONE: _wp-cli-docker-build"