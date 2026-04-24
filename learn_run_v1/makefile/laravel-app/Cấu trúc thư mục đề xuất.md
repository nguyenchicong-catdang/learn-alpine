#Cấu trúc thư mục đề xuất

/var/www/html/
├── laravel-app/          # Project chính
└── packages/             # Chứa các repo Git riêng
    ├── ncc-core/         # Git repo 1
    └── ncc-api-bridge/   # Git repo 2

Cấu hình composer.json ở Project Laravel

{
    "repositories": [
        {
            "type": "path",
            "url": "../packages/*",
            "options": {
                "symlink": true
            }
        }
    ],
    "require": {
        "ncc/core": "dev-main",
        "ncc/api-bridge": "dev-main"
    }
}

# Đăng ký trong Docker Compose (Cực kỳ quan trọng)

services:
  php-fpm:
    image: php-alpine-ncc
    volumes:
      - ./laravel-app:/var/www/html/laravel-app
      - ./packages:/var/www/html/packages  # Mount thêm đống package vào đây

# Cách ráp nối thực tế
composer require ncc/core:dev-main

# Giải pháp tối ưu: Git Submodules
# Thêm package ncc-core
git submodule add https://github.com/your-user/ncc-core.git packages/ncc-core

# Thêm package ncc-api-bridge
git submodule add https://github.com/your-user/ncc-api-bridge.git packages/ncc-api-bridge

## Quy trình làm việc thực tế cho team 10 người

git clone --recursive https://github.com/your-org/main-repo.git

Nếu chọn Submodules, khi một người mới join team và clone repo về, họ chỉ cần chạy 1 lệnh để kéo toàn bộ dàn "packages" về đúng vị trí:

Bash

git clone --recursive https://github.com/your-org/main-repo.git

Hoặc nếu đã clone rồi:

Bash

git submodule update --init --recursive

4. Lưu ý về Docker Sync
Khi bạn dùng Submodules hoặc nhiều Repo lồng nhau, hãy đảm bảo rằng khi bạn mount volume trong docker-compose.yml, các thư mục con này cũng được mount vào đúng vị trí trong container.

YAML
volumes:
  - .:/var/www/html  # Mount toàn bộ gốc (bao gồm cả packages và laravel-app)