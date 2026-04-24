exec nginx -g "daemon off;" 2>/dev/null || true

RUN chmod +x 

RUN chown nginx:nginx /run/nginx && \
	chmod -R /run/nginx

CMD ["nginx", "-g", "daemon off;"]

cat /etc/group

RUN chown root:nginx /run/nginx && \
	chmod -R775 /run/nginx

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


volumes:
   - ./default.conf:/etc/nginx/http.d/default.conf