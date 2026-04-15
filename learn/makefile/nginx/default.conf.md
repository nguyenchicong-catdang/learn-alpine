echo '<h1>Hello NCC</h1>' > /var/www/localhost/htdocs/index.html
cat /etc/nginx/http.d/default.conf

vi /etc/nginx/http.d/default.conf
server {
    listen 80;
    listen [::]:80;
    server_name _;

    # Đường dẫn thư mục web trên Alpine
    root /var/www/localhost/htdocs;
    index index.html index.htm;

    location / {
        # Thử tìm file, nếu không thấy thì trả về 404 (hoặc index.php cho Laravel)
        try_files $uri $uri/ =404;
    }
}

/var/www/localhost/htdocs;

echo '<h1>Hello NCC</h1>' > /var/www/localhost/htdocs/index.html

FROM alpine:3.23.3
RUN apk update && apk upgrade --no-cache && apk add --no-cache nginx

# TẠO SẴN VÀ CẤP QUYỀN: Đây là chìa khóa
RUN mkdir -p /run/nginx && chown -R nginx:nginx /run/nginx

EXPOSE 80

# Chạy Nginx với cấu hình daemon off
CMD ["nginx", "-g", "daemon off;"]

# 1. Tạo thư mục
RUN mkdir -p /run/nginx /var/www/localhost/htdocs

# 2. Cấp quyền sở hữu (Quan trọng nhất)
RUN chown -R nginx:nginx /run/nginx /var/www/localhost/htdocs

# 3. Cấp quyền truy cập thư mục (Nếu cẩn thận)
RUN chmod -R 755 /var/www/localhost/htdocs