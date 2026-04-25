# learn_w/adminer/_docker-cp.mk

_adminer-docker-cp:
	@echo "_adminer-docker-cp"
	docker rm -f $(ADMINER_NAME) 2>/dev/null || true
	
	docker create --name $(ADMINER_NAME) $(ADMINER_NAME)

	docker cp $(ADMINER_NAME):/app/adminer.php $(NGINX_PROJECT_PATH)/html

	docker rm $(ADMINER_NAME)