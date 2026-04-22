# learn/makefile/wp-app/_create-dockerfile.mk

define WP_APP_DOCKERFILE
FROM $(WP_CLI_IMAGE_NAME) AS source_code_$(WP_CLI_IMAGE_NAME)
# learn app => /var/www/html/app
WORKDIR /var/www/html/app

# tao image moi
FROM $(ALPINE_IMAGE)
# cai dat
RUN apk update && apk upgrade --no-cache && \
	apk add --no-cache nginx php84-fpm
# thiet lap thu muc lam viec
WORKDIR /var/www/html
# Cú pháp: --from=[name_stage] [path_source] [path_target]
COPY --from=source_code_$(WP_CLI_IMAGE_NAME) /var/www/html/app /var/www/html/app
# copy config
COPY wp-config.php /var/www/html/app/wp-config.php
endef

export WP_APP_DOCKERFILE

_wp-app-create-dockerfile: _wp-app-prepare
	@echo "RUN: _wp-app-create-dockerfile"
	@echo "$$WP_APP_DOCKERFILE" > $(WP_APP_PROJECT_PATH)/Dockerfile
	@echo "DONE: _wp-app-create-dockerfile"