ps aux | grep php-fpm

netstat -tulpn | grep php-fpm

# Xem log lỗi trực tiếp
tail -f /var/log/nginx/error.log

ls -l /var/www/html

# Chuyển chủ sở hữu cho user nginx
chown -R nginx:nginx /var/www/html
# Cấp quyền đọc
chmod -R 755 /var/www/html

SELECT user, host FROM mysql.user;