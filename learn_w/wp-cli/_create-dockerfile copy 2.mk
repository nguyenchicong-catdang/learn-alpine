# learn_w/wp-cli/_create-dockerfile.mk

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

# entripoint
COPY ./wp-cli.sh /usr/local/bin/wp-cli.sh
RUN chmod +x /usr/local/bin/wp-cli.sh

ENTRYPOINT ["/usr/local/bin/wp-cli.sh"]
COPY ./wp-config.php /root/wp-app/wp-config.php

WORKDIR /root

endef

export WP_CLI_DOCKERFILE

_wp-cli-create-dockerfile:
	@echo "_wp-cli-create-dockerfile"
	@echo "$$WP_CLI_DOCKERFILE" > $(WP_CLI_PROJECT_PATH)/Dockerfile