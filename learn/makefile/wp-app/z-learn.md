# File wp-config.php mẫu sử dụng Biến môi trường

<?php
/**
 * Cấu hình WordPress bằng Biến môi trường (Environment Variables)
 */

// --- Kết nối Database ---
define( 'DB_NAME',     getenv('DB_DATABASE') ?: 'wordpress' );
define( 'DB_USER',     getenv('DB_USERNAME') ?: 'root' );
define( 'DB_PASSWORD', getenv('DB_PASSWORD') ?: '' );
define( 'DB_HOST',     getenv('DB_HOST')     ?: 'localhost' );
define( 'DB_CHARSET',  'utf8mb4' );
define( 'DB_COLLATE',  '' );

// --- Các khóa bảo mật (Nên dùng biến môi trường hoặc ghi cứng vì nó ít thay đổi) ---
define( 'AUTH_KEY',         getenv('WP_AUTH_KEY')         ?: 'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  getenv('WP_SECURE_AUTH_KEY')  ?: 'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    getenv('WP_LOGGED_IN_KEY')    ?: 'put your unique phrase here' );
define( 'NONCE_KEY',        getenv('WP_NONCE_KEY')        ?: 'put your unique phrase here' );

// --- Thiết lập thư mục (Quan trọng cho Headless/Laravel) ---
$table_prefix = getenv('DB_PREFIX') ?: 'wp_';

// Bật debug nếu môi trường là local
define( 'WP_DEBUG',         getenv('WP_DEBUG') === 'true' );
define( 'WP_DEBUG_LOG',     true );
define( 'WP_DEBUG_DISPLAY', false );

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSOLUTE_PATH' ) ) {
	define( 'ABSOLUTE_PATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSOLUTE_PATH . 'wp-settings.php';


# Cách triển khai trong Dockerfile

# Stage build WordPress
WORKDIR /var/www/html/app

# 1. Tải code sạch
RUN wp core download --allow-root

# 2. Ghi đè file config "thông minh" của bạn vào
COPY ./my-custom-configs/wp-config.php ./wp-config.php

# Cách thức hoạt động trong Docker Compose

services:
  wp-app:
    image: wp-app-alpine-ncc
    env_file:
      - .env  # <--- Tất cả DB_DATABASE, DB_USERNAME... nằm ở đây

Trong Docker: Khi bạn dùng khai báo env_file: .env trong docker-compose.yml

docker exec -it wp-app-alpine-ncc php -r "echo getenv('DB_DATABASE');"