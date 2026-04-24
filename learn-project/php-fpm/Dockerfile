FROM alpine:3

RUN apk update && apk upgrade --no-cache && apk add --no-cache php84-fpm 
CMD ["php84-fpm", "-D", "-R"]
