# /home/git/learn-alpine/learn/makefile/nginx/nginx.mk
PATH_NGINX = $(PATH_PROJECT)/nginx
IMAGE_NAME = 'nginx-alpine-ncc'
# DOCKERFILE_CONTENT
include nginx/dockerfile_content.mk
export DOCKERFILE_CONTENT

# NGINX_CONF đã khả dụng ở đây
include nginx/nginx_conf.mk
export NGINX_CONF

# INDEX_HTML
#INDEX_HTML = $(shell cat nginx/index.html)

nginx-help:
	@echo "make nginx-build - build nginx image"
	@echo "make nginx-run - docker run nginx image"
	@echo "make nginx-reload - nginx reload"

nginx-build:
	mkdir -p $(PATH_NGINX)
	@echo "tao xong: $(PATH_NGINX)"
	@echo "$$DOCKERFILE_CONTENT" > $(PATH_NGINX)/Dockerfile
	@echo "Xong Dockerfile!"
	docker build --network host -t $(IMAGE_NAME) -f $(PATH_NGINX)/Dockerfile $(PATH_NGINX)

nginx-run:
	#docker rm -f $(IMAGE_NAME)
	@docker rm -f $(IMAGE_NAME) 2>/dev/null || true
	# docker run -d --name $(IMAGE_NAME) --network host $(IMAGE_NAME)

	# BƯỚC 1: Phải tạo file trước
	@mkdir -p $(PATH_NGINX)
	# default.conf
	@echo "$$NGINX_CONF" > $(PATH_NGINX)/default.conf
	# index.html
	# @echo "$(INDEX_HTML)" > $(PATH_NGINX)/index.html
	@mkdir -p $(PATH_NGINX)/html
	@cp nginx/index.html $(PATH_NGINX)/html/index.html

	docker run -d --name $(IMAGE_NAME) \
    --network host \
    -v $(PATH_NGINX)/html:/var/www/html \
    -v $(PATH_NGINX)/default.conf:/etc/nginx/http.d/default.conf \
    $(IMAGE_NAME)

nginx-reload:
	docker exec $(IMAGE_NAME) sh -c "nginx -s reload"