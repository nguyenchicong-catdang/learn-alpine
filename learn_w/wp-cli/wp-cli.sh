#!/bin/sh

# 1. Kiem tra neu WordPress chua cai thi moi tien hanh Install
if ! wp core is-installed --allow-root; then
    echo "Đang tiến hành cài đặt WordPress..."
    
    wp core install \
        --url="${WP_SITE_URL:-http://localhost}" \
        --title="${WP_SITE_TITLE:-My Alpine WP}" \
        --admin_user="${WP_ADMIN_USER:-admin}" \
        --admin_password="${WP_ADMIN_PASSWORD:-password123}" \
        --admin_email="${WP_ADMIN_EMAIL:-admin@example.com}" \
        --skip-email \
        --allow-root
        
    echo "Cài đặt hoàn tất!"
else
    echo "WordPress đã được cài đặt trước đó."
fi

# update option

# cat anh
# thumbnail_size_w
wp option update thumbnail_size_w 400 --autoload=on --allow-root || true
wp option update thumbnail_size_h 400 --autoload=on --allow-root || true

# medium_size_w

wp option update medium_size_w 0 --autoload=off --allow-root || true
wp option update medium_size_h 0 --autoload=off --allow-root || true

# large_size_w
wp option update large_size_w 0 --autoload=off --allow-root || true
wp option update large_size_h 0 --autoload=off --allow-root || true

# medium_large_size_w
wp option update medium_large_size_w 0 --autoload=off --allow-root || true
wp option update medium_large_size_h 0 --autoload=off --allow-root || true

# permalink_structure	/%postname%/

wp option update permalink_structure "/%postname%/" --allow-root || true
# note category_base

# QUAN TRỌNG: Phải chạy lệnh này để WordPress cập nhật lại hệ thống route
#wp rewrite flush --hard --allow-root
echo "Đang fix quyền hạn file..."
chown -R nobody:nobody /root/wp-app
chmod -R 755 /root/wp-app