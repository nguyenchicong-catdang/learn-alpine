# php dockerfile content
# var root makefile: IMAGE_ALPINE = alpine:3.23.3
define DOCKERFILE_CONTENT
FROM $(IMAGE_ALPINE)
RUN apk update && \
	apk upgrade --no-cache && \
	apk add --no-cache php

#expose test 9999
#EXPOSE 9999

WORKDIR /var/www/html

#CMD ["tail", "-f" "/dev/null"]
# CMD ["/bin/sh"]
CMD ["sh", "-c", "tail -f /dev/null"]
endef