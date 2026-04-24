# learn/makefile/wp-app/_create-dockerfile.mk

define WP_APP_DOCKERFILE
FROM $(WP_CLI_IMAGE_NAME) AS source_code_$(WP_CLI_IMAGE_NAME)
# learn app => /var/www/html/app
WORKDIR /var/www/html/app

# tao image moi
FROM $(ALPINE_IMAGE)
# cai dat
RUN apk update && apk upgrade --no-cache && \
	apk add --no-cache nginx \
		php84-fpm \
		php84-mysqli
# thiet lap thu muc lam viec
WORKDIR /var/www/html
# Cú pháp: --from=[name_stage] [path_source] [path_target]
COPY --from=source_code_$(WP_CLI_IMAGE_NAME) /var/www/html/app /var/www/html/app
# copy config
COPY wp-config.php /var/www/html/app/wp-config.php
# xu ly php-fpm84
RUN ln -s /usr/sbin/php-fpm84 /usr/sbin/php-fpm && \
	ln -s /etc/php84 /etc/php && \
	sed -i 's/^;*clear_env =.*/clear_env = no/' /etc/php/php-fpm.d/www.conf

# test
COPY index.html /var/www/html/index.html
COPY phpinfo.php /var/www/html/phpinfo.php
COPY test-env.php /var/www/html/test-env.php
# cap quyen nginx /var/www/html
# RUN chmod +x /var/www/html
endef

export WP_APP_DOCKERFILE

_wp-app-create-dockerfile: _wp-app-prepare
	@echo "RUN: _wp-app-create-dockerfile"
	@echo "$$WP_APP_DOCKERFILE" > $(WP_APP_PROJECT_PATH)/Dockerfile
	@echo "DONE: _wp-app-create-dockerfile"