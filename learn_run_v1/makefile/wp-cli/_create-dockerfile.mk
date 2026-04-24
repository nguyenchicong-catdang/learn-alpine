# learn/makefile/wp-cli/_create-dockerfile.mk

define WP_CLI_DOCKERFILE
FROM $(ALPINE_IMAGE)

RUN apk update && apk upgrade --no-cache && \
	apk add --no-cache \
	curl \
	php84 \
	php84-phar \
	php84-curl \
	php84-openssl \
	php84-iconv \
	php84-mbstring \
	php84-tokenizer \
	php84-mysqli \
	ca-certificates \
	tar \
	mariadb-client

# tao app trong html
WORKDIR /var/www/html

# copy wp-cli.sh
COPY wp-cli.sh /usr/local/bin/wp-cli.sh
#RUN chmod +x /usr/local/bin/wp-cli.sh
RUN chmod +x /usr/local/bin/wp-cli.sh && /usr/local/bin/wp-cli.sh
# 2. Ghi đè file config "thông minh" của bạn vào
COPY wp-config.php /var/www/html/app/wp-config.php
#ENTRYPOINT ["wp-cli.sh"]
endef

export WP_CLI_DOCKERFILE

_wp-cli-create-dockerfile: _wp-cli-prepare
	@echo "RUN: _wp-cli-create-dockerfile"
	@echo "$$WP_CLI_DOCKERFILE" > $(WP_CLI_PROJECT_PATH)/Dockerfile
	@echo "DONE: _wp-cli-create-dockerfile"