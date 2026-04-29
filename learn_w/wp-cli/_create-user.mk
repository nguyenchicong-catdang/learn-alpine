# learn_w/wp-cli/_create-user.mk

include wp-cli/.env

_wp-cli-create-user:
	@echo "_wp-cli-create-user"
	@echo "Waiting for Mariadb to be healthy..."
# 	# vong lap
	@until [ "$$(docker inspect --format='{{.State.Health.Status}}' $(MARIADB_NAME))" = "healthy" ]; do \
		echo "Still starting... (health: starting)"; \
		sleep 1; \
	done

	@echo "Create Database wp-app"

	@docker exec -it $(MARIADB_NAME) mariadb -u root -e \
		"CREATE DATABASE IF NOT EXISTS \`$(DB_DATABASE)\`; \
		CREATE USER IF NOT EXISTS '$(DB_USERNAME)'@'$(DB_HOST)' IDENTIFIED BY '$(DB_PASSWORD)'; \
		GRANT ALL PRIVILEGES ON \`$(DB_DATABASE)\`.* TO '$(DB_USERNAME)'@'$(DB_HOST)'; \
		FLUSH PRIVILEGES;"

# 	@echo "create user run wp-app"

# 	@docker exec -it mariadb-alpine-ncc mariadb -u root -e \
# 		"CREATE USER IF NOT EXISTS '$(DB_USERNAME)'@'$(DB_HOST)' IDENTIFIED BY '$(DB_PASSWORD)'; \
# 		GRANT ALL PRIVILEGES ON *.* TO '$(DB_USERNAME)'@'$(DB_HOST)' WITH GRANT OPTION; \
# 		FLUSH PRIVILEGES;"