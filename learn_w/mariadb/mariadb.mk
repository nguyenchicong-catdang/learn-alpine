# learn_w/mariadb/mariadb.mk

MARIADB_PROJECT_PATH = $(PROJECT_PATH)/mariadb
MARIADB_NAME = mariadb-alpine-ncc

include mariadb/_create-dockerfile.mk
include mariadb/_docker-build.mk
include mariadb/_create-docker-compose-yml.mk
include mariadb/_docker-compose.mk
# include mariadb/_create-user.mk
include mariadb/_check-init.mk
mariadb-help:
	@echo "help"

_mariadb-prepare:
	@echo "_mariadb-prepare"
	mkdir -p $(MARIADB_PROJECT_PATH)
	cp -f ./mariadb/mariadb.sh $(MARIADB_PROJECT_PATH)/mariadb.sh

mariadb-up: _mariadb-prepare
	@echo "mariadb-up"
	$(MAKE) _mariadb-create-dockerfile
	$(MAKE) _mariadb-docker-build
	$(MAKE) _mariadb-create-docker-compose-yml
	$(MAKE) _mariadb-docker-compose-up
	$(MAKE) _mariadb-check-init
mariadb-down:
	@echo "mariadb-down"
	$(MAKE) _mariadb-docker-compose-down

mariadb-down-v:
	@echo "mariadb-down-v"
	$(MAKE) _mariadb-docker-compose-down-v