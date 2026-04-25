# learn_w/adminer/adminer.mk

ADMINER_LINK = https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2-en.php
ADMINER_PROJECT_PAHT = $(PROJECT_PATH)/adminer
ADMINER_NAME = adminer-alpine-ncc

include adminer/_create-dockerfile.mk
include adminer/_docker-build.mk
include adminer/_docker-cp.mk

adminer-help:
	@echo "help"

_adminer-prepare:
	@echo "_adminer-prepare"
	mkdir -p $(ADMINER_PROJECT_PAHT)

adminer-up: _adminer-prepare
	@echo "adminer-up"
	$(MAKE) _adminer-create-dockerfile
	$(MAKE) _adminer-docker-build

	$(MAKE) _adminer-docker-cp
