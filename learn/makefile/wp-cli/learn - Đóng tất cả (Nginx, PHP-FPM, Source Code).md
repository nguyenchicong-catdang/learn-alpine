# Đóng tất cả (Nginx, PHP-FPM, Source Code)
Chúc mừng bạn đã login thành công vào Dashboard! Nhìn ảnh thì thấy site đang chạy **WordPress 6.9.4** (một bản khá cũ so với hiện tại là 6.5+) và đang gặp lỗi thiếu extension `XML` hoặc `PCRE`.

Để trả lời câu hỏi của bạn: **Đóng tất cả (Nginx, PHP-FPM, Source Code) vào 1 Image duy nhất** (thường gọi là kiến trúc "Fat Container"), bạn cần giải quyết vấn đề lớn nhất là Docker mặc định chỉ chạy **một** tiến trình chính (PID 1).

Dưới đây là 3 cách để bạn thực hiện trên Alpine:

---

### Cách 1: Dùng Entrypoint Script (Cách thủ công & Nhẹ nhất)
Bạn viết một script `.sh` để khởi động cả 2 dịch vụ và giữ cho container không bị tắt.

**1. Tạo file `entrypoint.sh`:**
```bash
#!/bin/sh

# Khởi động PHP-FPM (chạy ngầm - daemonize)
php-fpm81 -D

# Khởi động Nginx (chạy ở foreground để container không exit)
nginx -g 'daemon off;'
```

**2. Trong Dockerfile:**
```dockerfile
FROM alpine:3.18
# Install nginx, php-fpm, extensions...
# Copy source code...

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
```

---

### Cách 2: Dùng Supervisord (Cách chuyên nghiệp & Ổn định nhất)
Đây là cách tiêu chuẩn nếu bạn muốn quản lý nhiều tiến trình. Nếu PHP-FPM bị crash, Supervisord sẽ tự động khởi động lại nó.

**1. Cấu hình `supervisord.conf`:**
```ini
[supervisord]
nodaemon=true
user=root

[program:php-fpm]
command=php-fpm81 -F
autostart=true
autorestart=true

[program:nginx]
command=nginx -g 'daemon off;'
autostart=true
autorestart=true
```

**2. Trong Dockerfile:**
```dockerfile
RUN apk add --no-cache supervisor
COPY supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
```

---

### Cách 3: Dùng Công cụ chuyên dụng (S6-Overlay)
Các image chuyên dụng cho Alpine (như của LinuxServer.io) thường dùng **s6-overlay**. Nó cực kỳ nhẹ và quản lý vòng đời tiến trình rất tốt, nhưng cấu hình sẽ hơi phức tạp hơn một chút cho người mới.

---

### Ưu và Nhược điểm của việc "Gom tất cả vào một":

| Đặc điểm | Một Image Duy Nhất (Fat Container) | Chia tách (Microservices) |
| :--- | :--- | :--- |
| **Tiện lợi** | Copy 1 file image là chạy được cả web. | Phải quản lý nhiều container qua Compose. |
| **Giao tiếp** | Nginx nối PHP qua `127.0.0.1` hoặc socket nhanh. | Phải qua mạng Docker (bridge). |
| **Resource** | Tiết kiệm RAM (chỉ 1 OS Alpine). | Tốn RAM hơn một chút cho nhiều OS ảo. |
| **Up/Down** | Restart là chết cả cụm Nginx + PHP. | Có thể update PHP mà không làm gián đoạn Nginx. |

**Lời khuyên cho bạn:**
Vì bạn đang làm dự án theo hướng **Headless CMS** (WordPress làm backend cho Laravel), việc đóng gói tất cả vào 1 Image cực kỳ phù hợp để triển khai nhanh lên các server vệ tinh hoặc môi trường test.

**Lưu ý quan trọng cho "nỗi đau" của bạn:**
Trong ảnh có lỗi `RSS Error: XML or PCRE extensions not loaded!`. Khi build image mới, hãy nhớ cài thêm:
```bash
apk add php81-xml php81-xmlreader php81-pcre
```

Bạn muốn mình viết thử một cái **Dockerfile** hoàn chỉnh gom cả 3 thứ (Nginx + PHP + Code WP) theo cách dùng **Supervisord** không? Chạy cái này thì `docker run` hay `up/down` cực kỳ nhàn.

# tham khao Giải pháp: Dùng tini (Lightweight Init)

# Cài tini và các dịch vụ cần thiết
RUN apk add --no-cache tini nginx php81-fpm

# Copy file khởi động của bạn
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Chạy qua tini để đảm bảo an toàn hệ thống
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/entrypoint.sh"]

## File entrypoint.sh kiểu "Service" (Tối ưu RAM)

#!/bin/sh

# 1. Khởi động PHP-FPM ngầm
php-fpm81

# 2. Khởi động Nginx ngầm
nginx

echo "Dàn NCC đã sẵn sàng..."

# 3. Vòng lặp kiểm tra (Health Check)
# Nó sẽ kiểm tra xem cả 2 tiến trình có còn sống không
while sleep 60; do
  ps aux | grep php-fpm | grep -v grep > /dev/null
  PHP_STATUS=$?
  ps aux | grep nginx | grep -v grep > /dev/null
  NGINX_STATUS=$?

  # Nếu một trong hai ông chết, script sẽ exit (làm container restart)
  if [ $PHP_STATUS -ne 0 ] || [ $NGINX_STATUS -ne 0 ]; then
    echo "Phát hiện dịch vụ bị sập. Đang dừng container để khởi động lại..."
    exit 1
  fi
done

ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log