# learn_w/adminer/_docker-build.mk

_adminer-docker-build:
	@echo "_adminer-docker-build"

	docker build --network host -t $(ADMINER_NAME) \
		-f $(ADMINER_PROJECT_PAHT)/Dockerfile \
		$(ADMINER_PROJECT_PAHT)