# learn_w/mariadb/_docker-build.mk


_mariadb-docker-build:
	@echo "_mariadb-docker-build"

	docker build --network host -t $(MARIADB_NAME) \
		-f $(MARIADB_PROJECT_PATH)/Dockerfile \
		$(MARIADB_PROJECT_PATH)