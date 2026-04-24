# learn/makefile/adminer/docker-run.mk

_adminer-repare-prepare:
	mkdir -p $(ADMINER_PATH_APP)
	mkdir -p $(ADMINER_PATH_APP)/html

adminer-docker-run-dev: _adminer-repare-prepare
	@echo "RUN - adminer-docker-run-dev"
	docker rm -f $(ADMINER_IMAGE) 2>/dev/null || true

	docker run -d --name $(ADMINER_IMAGE) \
		--network host \
		-v $(ADMINER_PATH_APP)/html:/var/www/html \
		$(ADMINER_IMAGE)

	@echo "RUN - adminer-docker-run-dev"
	
	docker ps



