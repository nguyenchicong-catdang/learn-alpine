# learn_w/adminer/_create-dockerfile.mk

define ADMINER_DOCKER_FILE
FROM $(ALPINE_IMAGE)

RUN apk update && apk upgrade --no-cache & \
	apk add --no-cache \
		curl

WORKDIR /app

RUN curl -L $(ADMINER_LINK) -o /app/adminer.php
endef

export ADMINER_DOCKER_FILE

_adminer-create-dockerfile:
	@echo "_adminer-create-dockerfile"
	@echo "$$ADMINER_DOCKER_FILE" > $(ADMINER_PROJECT_PAHT)/Dockerfile
