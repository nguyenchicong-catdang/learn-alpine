# learn_w/mariadb/_check-init.mk

include mariadb/_create-user.mk

_mariadb-check-init:
	@echo "Checking if database is already initialized..."
	@if docker exec -i $(MARIADB_NAME) [ -d "/var/lib/mysql/mysql" ]; then \
		echo "Database already exists. Skipping init."; \
	else \
		echo "Database is empty. Proceeding with setup..."; \
		$(MAKE) _mariadb-create-user; \
	fi