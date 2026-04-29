# learn_w/wp-cli/_docker-build.mk

_wp-cli-docker-build:
	@echo "_wp-cli-docker-build"
	docker build --network host -t $(WP_CLI_NAME) \
		-f $(WP_CLI_PROJECT_PATH)/Dockerfile \
		$(WP_CLI_PROJECT_PATH)