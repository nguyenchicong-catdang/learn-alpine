define DOCKERFILE_CONTENT
FROM $(IMAGE_ALPINE)
RUN apk update && \
	apk upgrade --no-cache && \
	apk add --no-cache nginx
# Thêm dòng này vào
EXPOSE 80
# WORK
WORKDIR /var/www/html

CMD ["nginx", "-g", "daemon off;"]
endef