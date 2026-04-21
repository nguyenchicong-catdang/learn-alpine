# learn/makefile/adminer/create-dockerfile.mk
# DOCKERFILE_CONTENT_PRO
define DOCKERFILE_CONTENT_PRO
FROM $(IMAGE_ALPINE)
RUN apk update && \
	apk upgrade --no-cache && \
	apk add --no-cache php-fpm

#expose test 8000
EXPOSE $(ADMINER_EXPOSE)

WORKDIR $(ADMINER_WORKDIR)

#CMD ["php", "-S", "0.0.0.0:8888", "-t", "/var/www/html"]
CMD ["sh", "-c", "tail -f /dev/null"]
endef
export DOCKERFILE_CONTENT_PRO

# DOCKERFILE_CONTENT_DEV
define DOCKERFILE_CONTENT_DEV
FROM $(IMAGE_ALPINE)
RUN apk update && \
	apk upgrade --no-cache && \
	apk add --no-cache nginx php84-fpm php84-mysqli php84-session

# Copy file cấu hình và entrypoint
COPY adminer.sh /usr/local/bin/adminer.sh
RUN chmod +x /usr/local/bin/adminer.sh

#expose test 8000
EXPOSE $(ADMINER_EXPOSE)

WORKDIR $(ADMINER_WORKDIR)

ENTRYPOINT ["adminer.sh"]

#CMD ["php", "-S", "0.0.0.0:8888", "-t", "/var/www/html"]
#CMD ["sh", "-c", "tail -f /dev/null"]
endef
export DOCKERFILE_CONTENT_DEV

# DOCKERFILE_CONTENT
export DOCKERFILE_CONTENT := $(DOCKERFILE_CONTENT_DEV)

# 	APP_ENV = development
# 	loi do khong su dung ip4: --network host

# BUILD_OPTS :=
# 	# Để ở phần đầu file .mk
ifeq ($(APP_ENV), development)
	BUILD_OPTS := --network host
	DOCKERFILE_CONTENT := $(DOCKERFILE_CONTENT_DEV)
	ADMINER_BUILD_STEPS := _adminer-prepare _adminer-create-dockerfile _adminer-docker-build
else
	BUILD_OPTS :=
	DOCKERFILE_CONTENT := $(DOCKERFILE_CONTENT_PRO)
	ADMINER_BUILD_STEPS := _adminer-prepare _adminer-create-dockerfile _adminer-docker-build
endif

# DOCKERFILE_CONTENT
export DOCKERFILE_CONTENT



adminer-docker-build-init: $(ADMINER_BUILD_STEPS)
# 	development
	@echo "DONE BUILD - adminer-docker-build-init cho $(APP_ENV)"

#prepare
# _adminer-prepare:
# 	mkdir -p $(ADMINER_PATH_APP)
# 	mkdir -p $(ADMINER_PATH_APP)/html

# build
_adminer-docker-build:
	@echo "BUILD - adminer-create-dockerfile"
	cp -f adminer/adminer.sh $(ADMINER_PATH_APP)/adminer.sh

	@echo "$(ADMINER_IMAGE)"
# 	# mount html
# 	APP_ENV = development
# 	loi do khong su dung ip4: --network host
	echo "$(BUILD_OPTS)"

	docker build -t $(ADMINER_IMAGE) \
		$(BUILD_OPTS) \
		-f $(ADMINER_PATH_APP)/Dockerfile $(ADMINER_PATH_APP)

	@echo "DONE BUILD - adminer-create-dockerfile"
	docker images

_adminer-create-dockerfile:
	@echo "CREATE - adminer-create-dockerfile"
	@echo "$$DOCKERFILE_CONTENT" > $(ADMINER_PATH_APP)/Dockerfile
	@echo "DONE CREATE - adminer-create-dockerfile"
