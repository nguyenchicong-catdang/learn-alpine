# learn/makefile/laravel-app/laravel-app.mk

PATH_PROJECT_LARRAVEL_APP = $(PATH_PROJECT)/laravel-app
# image name + container name
IMAGE_NAME = 'laravel-app-alpine-ncc'
# WORKDIR => WORKDIR /var/www/html ( xu ly ben makecontent - de sau)
WORKDIR_IMAGE = /var/www/html

# php extensions
PHP_EXTENSIONS = php-pdo php-pdo_mysql php-session

# DOCKERFILE_CONTENT
include laravel-app/dockerfile_content.mk
export DOCKERFILE_CONTENT

laravel-app-help:
	@echo "make laravel-app-build - laravel-app-build"
	@echo "make laravel-app-setup - laravel-app-setup"
	@echo "make laravel-app-docker-run-dev - laravel-app-docker-run-dev"

laravel-app-build:
	@echo "_BUILD_"
	mkdir -p $(PATH_PROJECT_LARRAVEL_APP)
	@echo "$$DOCKERFILE_CONTENT" > $(PATH_PROJECT_LARRAVEL_APP)/Dockerfile
	docker build --network host -t $(IMAGE_NAME) -f $(PATH_PROJECT_LARRAVEL_APP)/Dockerfile $(PATH_PROJECT_LARRAVEL_APP)
	@echo "_DONE_"
	docker images

laravel-app-setup:
	@echo "_SETUP_"
	mkdir -p $(PATH_PROJECT_LARRAVEL_APP)
	mkdir -p $(PATH_PHP)/html

laravel-app-docker-run-dev:
	$(MAKE) laravel-app-setup
	@echo "_RUN: laravel-app-setup _"
	docker rm -f $(IMAGE_NAME) 2>/dev/null || true

	docker run -d --name $(IMAGE_NAME) \
	--network host \
	-v $(PATH_PROJECT_LARRAVEL_APP)/html:/var/www/html \
	$(IMAGE_NAME)

	docker ps

laravel-app-down:
	docker rm -f $(IMAGE_NAME) 2>/dev/null || true


