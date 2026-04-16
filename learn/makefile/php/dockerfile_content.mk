# php dockerfile content
# var root makefile: IMAGE_ALPINE = alpine:3.23.3
define DOCKERFILE_CONTENT
FROM $(IMAGE_ALPINE)
RUN apk update && \
	apk upgrade --no-cache && \
	apk add --no-cache php

#expose test 8888
EXPOSE 8888

WORKDIR /var/www/html

CMD ["php", "-S", "0.0.0.0:8888", "-t", "/var/www/html"]
endef