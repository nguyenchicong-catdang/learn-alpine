FROM alpine:3
RUN apk update && apk upgrade --no-cache && apk add --no-cache nginx

WORKDIR /var/www/html

RUN chmod +x /run/nginx /var/www/html

CMD ["nginx", "-g", "daemon off;"]
