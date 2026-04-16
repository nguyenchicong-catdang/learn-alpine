Để "đóng gói" toàn bộ quá trình vất vả vừa rồi vào một cái **Makefile** chuẩn chỉnh, giúp bạn sau này chỉ cần gõ một lệnh là có ngay môi trường "full giáp", chúng ta sẽ chia ra làm 2 phần: **Dockerfile** (để chứa các extension bạn đã tìm ra) và **Makefile** (để điều khiển).

Dưới đây là cấu trúc tối ưu cho dự án của bạn:

### 1. Dockerfile (Cập nhật tất cả "mảnh ghép" đã fix)
Lưu file này tại `/home/git/learn-alpine/learn/project-test/wp-cli/Dockerfile`.

```dockerfile
FROM alpine:3.23.3

# Cài đặt PHP 8.4 và các extension "sống còn" đã tìm ra
RUN apk update && apk add --no-cache \
    php84 \
    php84-phar \
    php84-mysqli \
    php84-openssl \
    php84-curl \
    php84-gd \
    php84-mbstring \
    php84-iconv \
    php84-zip \
    php84-tokenizer \
    php84-ctype \
    mariadb-client \
    curl \
    tar \
    ca-certificates \
    coreutils

# Tăng Memory Limit để không bị lỗi "Memory Exhausted" khi download/unzip
RUN echo "memory_limit=512M" > /etc/php84/conf.d/memory-limit.ini

# Cài đặt WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

# Lệnh treo container để không bị thoát (PID 1)
CMD ["tail", "-f", "/dev/null"]
```

---

### 2. Makefile (Điều khiển từ xa)
Makefile này sẽ giúp bạn build, chạy và nhảy vào container cực nhanh.

```makefile
# Khai báo biến
IMAGE_NAME = wp-cli-alpine-ncc
CONTAINER_NAME = wp-cli-worker
DOCKERFILE_PATH = ./project-test/wp-cli/Dockerfile
CONTEXT_PATH = ./project-test/wp-cli

.PHONY: build run stop shell clean setup-wp

# 1. Build Image
build:
	docker build --network host -t $(IMAGE_NAME) -f $(DOCKERFILE_PATH) $(CONTEXT_PATH)

# 2. Chạy Container (Chế độ detached)
run:
	docker rm -f $(CONTAINER_NAME) || true
	docker run -d --network host --name $(CONTAINER_NAME) $(IMAGE_NAME)

# 3. Nhảy vào "bụng" container để gõ lệnh
shell:
	docker exec -it $(CONTAINER_NAME) sh

# 4. Lệnh "One-Click" để cài đặt WordPress nhanh
# Lưu ý: Sửa các thông số dbhost, dbuser theo ý bạn
setup-wp:
	docker exec -it $(CONTAINER_NAME) wp core download --allow-root
	docker exec -it $(CONTAINER_NAME) wp config create --dbname=test --dbuser=test --dbpass=123456 --dbhost=127.0.0.1 --allow-root
	docker exec -it $(CONTAINER_NAME) wp core install --url=localhost:8080 --title="Blog của Cong" --admin_user=admin --admin_password=adminpass --admin_email=cong@example.com --allow-root

# 5. Dọn dẹp
clean:
	docker rm -f $(CONTAINER_NAME)
	docker rmi $(IMAGE_NAME)
```

---

### 3. Cách sử dụng "nhàn hạ"

Từ giờ trở đi, quy trình của bạn chỉ còn là:

1.  **`make build`**: Tạo ra cái "kén" có đủ PHP 8.4, GD, Phar...
2.  **`make run`**: Phóng container lên.
3.  **`make shell`**: Vào vọc vạch nếu thích.
4.  **`make setup-wp`**: Tự động tải, tạo config và cài đặt WordPress trong 5 giây.



### Tại sao Makefile này lại "đáng đồng tiền bát gạo"?
* **Tham số `--allow-root`**: Được tích hợp sẵn trong các lệnh để bạn không phải gõ đi gõ lại.
* **Tính di động**: Bạn có thể mang bộ này sang bất kỳ máy nào có Docker, gõ `make build run` là nó tái hiện y hệt cái trạng thái bạn vừa fix xong.
* **Gọn gàng**: Nó quản lý tên Container và Image đồng nhất, không bị lỗi "invalid reference format" như lúc nãy nữa.

Bạn thấy cái "One-Click" `setup-wp` này đã đủ độ "phê" chưa, hay cần thêm lệnh tự động cài luôn bộ Plugin/Theme tủ của bạn vào nữa?