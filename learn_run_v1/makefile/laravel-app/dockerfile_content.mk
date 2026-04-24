# php dockerfile content
# var root makefile: IMAGE_ALPINE = alpine:3.23.3
define DOCKERFILE_CONTENT
FROM $(IMAGE_ALPINE)
RUN apk update && \
	apk upgrade --no-cache && \
	apk add --no-cache php composer

#expose test 8000
EXPOSE 8000

WORKDIR /var/www/html

#CMD ["php", "-S", "0.0.0.0:8888", "-t", "/var/www/html"]
CMD ["sh", "-c", "tail -f /dev/null"]
endef