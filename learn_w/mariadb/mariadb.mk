# learn_w/mariadb/mariadb.mk

MARIADB_PROJECT_PATH = $(PROJECT_PATH)/mariadb
MARIADB_NAME = mariadb-alpine-ncc

include mariadb/_create-dockerfile.mk
include mariadb/_docker-build.mk
include mariadb/_create-docker-compose-yml.mk
include mariadb/_docker-compose.mk
include mariadb/_create-user.mk

mariadb-help:
	@echo "help"

_mariadb-prepare:
	@echo "_mariadb-prepare"
	mkdir -p $(MARIADB_PROJECT_PATH)

mariadb-up: _mariadb-prepare
	@echo "mariadb-up"
	$(MAKE) _mariadb-create-dockerfile
	$(MAKE) _mariadb-docker-build
	$(MAKE) _mariadb-create-docker-compose-yml
	$(MAKE) _mariadb-docker-compose-up
	$(MAKE) _mariadb-create-user
mariadb-down:
	@echo "mariadb-down"
	$(MAKE) _mariadb-docker-compose-down