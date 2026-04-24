# Giữ cửa Admin - Chặn cửa chính
Ý tưởng của bạn rất thực tế: Bạn muốn dùng trang `index.php` của WordPress làm "trạm điều hướng" (Router) để **chỉ giữ lại những gì thuộc về Admin**, còn lại khách vãng lai vào trang chủ (`/`) là "đá" sang Laravel hết.

Vì bạn lười viết plugin, bạn hoàn toàn có thể tống hết logic này vào file **`functions.php`** của theme. Đây là cách giải quyết triệt để bài toán: **Giữ cửa Admin - Chặn cửa chính.**

### 1. Logic: "Giữ nách, chặn cổng"
Bạn cần một bộ lọc kiểm tra: Nếu là yêu cầu đăng nhập, quản trị, hoặc API thì cho qua. Nếu là truy cập vào trang chủ hoặc bài viết thì đẩy đi.

Thêm đoạn này vào `functions.php`:

```php
add_action('init', function() {
    // 1. Danh sách các "vùng cấm" không được redirect (để Admin làm việc)
    $exclude_paths = [
        'wp-admin',
        'wp-login.php',
        'wp-json',       // Giữ lại để Laravel gọi API
        'wp-cron.php',   // Giữ lại để WP chạy các tác vụ ngầm
        'wp-content',    // Giữ lại để load ảnh/script trong admin
        'wp-includes'
    ];

    $current_uri = $_SERVER['REQUEST_URI'];

    // 2. Kiểm tra xem URI hiện tại có nằm trong danh sách loại trừ không
    foreach ($exclude_paths as $path) {
        if (strpos($current_uri, $path) !== false) {
            return; // Nếu dính tới admin/api thì dừng lại, cho chạy tiếp WP
        }
    }

    // 3. Nếu không thuộc admin, và đang truy cập Frontend (trang chủ, post...)
    // Đẩy sang Laravel ngay lập tức
    $laravel_url = 'https://your-laravel-site.com' . $current_uri;
    
    wp_redirect($laravel_url, 302); // Dùng 302 để test, ổn thì đổi sang 301
    exit;
});
```

---

### 2. Tại sao dùng `init` thay vì sửa file `index.php`?
Nếu bạn sửa trực tiếp file `index.php` ở thư mục gốc của WordPress:
* Mỗi lần WordPress cập nhật (update core), nó có thể ghi đè mất file đó.
* Dùng hook `init` trong `functions.php` là cách "lành" nhất vì nó chạy ngay sau khi WordPress vừa khởi động nhưng chưa kịp render giao diện, giúp **tiết kiệm RAM** vì PHP không phải load cả đống logic của Theme.

### 3. "Tuyệt chiêu" cho trang Index của Theme
Để cho "sạch" và đúng chất Headless, bạn vào thư mục theme (`wp-content/themes/your-theme/`), mở file `index.php` ra và xóa sạch code cũ, thay bằng:

```php
<?php
// Im lặng là vàng - File này gần như không bao giờ được chạm tới 
// vì hook 'init' ở trên đã xử lý redirect hết rồi.
exit; 
```

---

### 4. Kết quả thực tế của dàn "NCC"
Bây giờ hệ thống của bạn sẽ vận hành như sau:
* **Gõ `127.0.0.1:8080/`:** Bị đá sang `laravel-site.com/` ngay.
* **Gõ `127.0.0.1:8080/wp-admin`:** Vào thẳng trang quản trị mượt mà.
* **Gõ `127.0.0.1:8080/wp-json/wp/v2/posts`:** Trả về JSON cho Laravel bình thường.

### Mẹo nhỏ cho việc "Lười":
Nếu bạn lười đến mức không muốn mở FTP/File Manager để sửa code, bạn có thể vào trực tiếp **Appearance -> Theme File Editor** trong giao diện WP-Admin để dán đoạn code trên vào `functions.php`.

Cách này có đúng ý bạn là **"vẫn vào được URL login nhưng chặn sạch trang chủ"** không? Với bộ lọc `$exclude_paths` ở trên, bạn nắm toàn quyền sinh sát trong tay rồi đấy!