# learn_w/wp-cli/_docker-cp.mk

_wp-cli-docker-cp.mk:
	@echo "_wp-cli-docker-cp.mk"
	@echo "Creating temporary container to copy files..."
	docker rm -f tmp-$(WP_CLI_NAME) 2>/dev/null || true
	docker run --network host --name tmp-$(WP_CLI_NAME) $(WP_CLI_NAME)
	docker cp tmp-$(WP_CLI_NAME):/root/wp-app $(NGINX_CP_HTML)
	docker rm -f tmp-$(WP_CLI_NAME) 2>/dev/null || true