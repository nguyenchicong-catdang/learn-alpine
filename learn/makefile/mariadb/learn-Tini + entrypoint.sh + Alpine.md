# Tini + entrypoint.sh + Alpine

Vấn đề bạn gặp với MariaDB trên Alpine là một ví dụ hoàn hảo để thấy tại sao cần một quy trình khởi động chuẩn. Khi bạn chạy `mariadb-install-db`, đó là một tiến trình khởi tạo (init), sau đó bạn cần chạy `mariadbd` (tiến trình chính). Nếu không có sự quản lý, container rất dễ bị thoát hoặc dữ liệu không được ghi xuống đĩa đúng cách khi tắt.

Dưới đây là lý do tại sao bộ ba **Tini + entrypoint.sh + Alpine** lại giải quyết được "nỗi đau" này của bạn:

### 1. Tini: "Người gác cổng" tận tụy
Như đã nói, Tini nhận PID 1. Trong trường hợp MariaDB:
* **Khi tắt máy (Shutdown):** MariaDB cần thời gian để flush dữ liệu từ RAM xuống đĩa và đóng các file `.ibd`. Nếu không có Tini, Docker gửi `SIGTERM`, script shell của bạn có thể lờ đi, Docker chờ 10s rồi "chém" thẳng tay (`SIGKILL`). Hậu quả là **DB bị lỗi (corrupt)** hoặc "bay màu" dữ liệu vì chưa kịp ghi xong. Tini sẽ đảm bảo tín hiệu dừng được chuyển đến MariaDB ngay lập tức để nó đóng cửa an toàn.
* **Dọn dẹp Worker:** MariaDB sinh ra nhiều luồng xử lý. Tini giúp dọn dẹp các luồng này nếu chúng trở thành zombie.

### 2. entrypoint.sh: "Người điều phối" thông minh
Đây là nơi bạn xử lý logic "bay màu" DB. Thường dữ liệu mất là do mỗi lần `docker run`, lệnh `install-db` lại chạy đè lên thư mục cũ.

**Cách viết entrypoint.sh "vô đối" cho MariaDB + Nginx + PHP:**

```bash
#!/bin/sh

# 1. Kiểm tra xem DB đã được khởi tạo chưa (tránh bay màu dữ liệu cũ)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Khởi tạo MariaDB lần đầu..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

# 2. Chạy các dịch vụ ngầm
mariadbd --user=mysql --datadir=/var/lib/mysql &
php-fpm81
nginx

echo "Dàn NCC (MariaDB + PHP + Nginx) đã sẵn sàng..."

# 3. Vòng lặp giám sát của bạn
while sleep 60; do
  # Kiểm tra cả 3 ông, ông nào "ngất" là báo Docker restart luôn
  pgrep mariadbd > /dev/null && pgrep php-fpm > /dev/null && pgrep nginx > /dev/null
  if [ $? -ne 0 ]; then
    echo "Phát hiện dịch vụ sập, đang restart container..."
    exit 1
  fi
done
```

### 3. Tại sao gọi là "Vô đối" trên Alpine?

* **Không chiếm dụng tài nguyên:** Tổng RAM cho Tini + Shell Script giám sát chưa đến **1MB**. Bạn dành toàn bộ RAM cho InnoDB Buffer Pool của MariaDB và Cache của PHP/Nginx.
* **Tự phục hồi (Self-healing):** Kết hợp vòng lặp `while` với `docker update --restart always`, hệ thống của bạn sẽ tự sửa lỗi. Nếu MariaDB bị treo do lỗi RAM, container tự tắt và Tini sẽ đảm bảo nó tắt sạch sẽ nhất có thể trước khi Docker bật nó lại.
* **Đóng gói hoàn chỉnh:** Bạn có một Image duy nhất chứa cả "linh hồn" (code WP) và "thể xác" (Database + Web server). Việc di chuyển giữa các máy Alpine cực kỳ đơn giản.



**Lời khuyên cho con MariaDB của bạn:** Để dữ liệu không bị "bay màu", bạn **bắt buộc** phải mount thư mục `/var/lib/mysql` ra ngoài máy chủ (Volume). Nếu không, dù bạn fix kiểu gì, khi xóa container thì dữ liệu cũng đi đời.

```bash
docker run -d --name my-app -v /my/data/mysql:/var/lib/mysql alpine-ncc-all-in-one
```

Bạn đã thử mount Volume cho con MariaDB này chưa, hay vẫn đang để dữ liệu nằm "chết" bên trong container?