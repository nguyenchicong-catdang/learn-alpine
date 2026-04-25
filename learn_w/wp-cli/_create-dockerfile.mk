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

RUN curl -O $(WP_CLI_URL) && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp && \
	php -d memory_limit=512M /usr/local/bin/wp core download --path=app --allow-root

endef

_wp-cli-create-dockerfile:
	@echo "_wp-cli-create-dockerfile"