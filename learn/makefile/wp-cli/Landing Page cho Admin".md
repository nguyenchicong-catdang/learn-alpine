# Landing Page cho Admin"
Hiểu ý bạn rồi! Tức là bạn muốn trang chủ (`/`) của WordPress đóng vai trò như một **"Trang Dashboard nội bộ"** hoặc **"Landing Page cho Admin"**. 

Khách vãng lai gõ URL bài viết thì bị đá sang Laravel, nhưng nếu gõ đúng URL gốc của server thì hiện ra một danh sách các "phím tắt" để Admin bấm cho nhanh (vào Admin, vào Database, vào Laravel, v.v.).

Dưới đây là cách thực hiện "khô máu" trong `functions.php` và `index.php` của theme:

### 1. Cấu hình Logic trong `functions.php`

Chúng ta sẽ sửa lại điều kiện: Nếu là trang chủ đích danh (`/`) thì **không redirect**, để nó load file `index.php` của theme.

```php
add_action('init', function() {
    // 1. Danh sách loại trừ
    $exclude_paths = [
        'wp-admin',
        'wp-login.php',
        'wp-json',
        'wp-cron.php',
        'wp-content',
        'wp-includes'
    ];

    $current_uri = $_SERVER['REQUEST_URI'];

    // 2. Nếu là trang chủ "/" (hoặc rỗng), cho qua để hiện index theme
    if ($current_uri === '/' || empty($current_uri)) {
        return;
    }

    // 3. Kiểm tra các vùng admin khác
    foreach ($exclude_paths as $path) {
        if (strpos($current_uri, $path) !== false) {
            return;
        }
    }

    // 4. Còn lại (bài viết, category...) -> Đá sang Laravel
    $laravel_url = 'https://your-laravel-site.com' . $current_uri;
    wp_redirect($laravel_url, 302);
    exit;
});
```

---

### 2. Viết nội dung cho `index.php` của Theme

Đây là nơi bạn để các "thẻ A" cho Admin. Vì bạn lười viết plugin, hãy biến file này thành một cái bảng điều khiển siêu nhẹ:

```php
<?php
/**
 * Trang Dashboard tối giản cho Admin NCC
 */
?>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NCC Headless WP Control</title>
    <style>
        body { font-family: sans-serif; background: #f0f2f5; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: white; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); text-align: center; }
        h1 { color: #1d2327; font-size: 1.5rem; margin-bottom: 1.5rem; }
        .links { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        a { text-decoration: none; color: white; background: #2271b1; padding: 12px 20px; border-radius: 6px; font-weight: bold; transition: 0.2s; }
        a:hover { background: #135e96; }
        a.secondary { background: #646970; }
        a.laravel { background: #ff2d20; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🚀 NCC Headless Control</h1>
        <div class="links">
            <a href="/wp-admin/">Vào WP Admin</a>
            <a href="/wp-login.php?action=logout" class="secondary">Đăng xuất</a>
            <a href="https://your-laravel-site.com" target="_blank" class="laravel">Mở Laravel</a>
            <a href="http://127.0.0.1:8081" target="_blank" class="secondary">Adminer / DB</a>
        </div>
        <p style="margin-top: 1.5rem; font-size: 0.8rem; color: #888;">IP: <?php echo $_SERVER['SERVER_ADDR']; ?> | RAM: Alpine-NCC Optimized</p>
    </div>
</body>
</html>
```

---

### 3. Tại sao bộ đôi này lại "Hợp lý"?

1.  **Trải nghiệm Admin:** Khi bạn gõ `127.0.0.1:8080`, thay vì bị đá văng đi hoặc hiện cái theme trắng nhách, bạn có ngay một cái Menu đẹp để chọn việc cần làm.
2.  **Bảo mật "vui vẻ":** Khách vãng lai gõ URL bài viết thì không bao giờ thấy WordPress. Chỉ khi họ gõ đúng IP/Domain gốc thì mới thấy cái bảng điều khiển (mà bạn có thể thêm mật khẩu cho trang này nếu thích).
3.  **Tối ưu RAM:** File `index.php` này không gọi `get_header()`, không gọi `wp_head()`, không load bất kỳ CSS/JS nào của WordPress. Nó là một file HTML thuần, tốn **0.0001MB RAM** để render.



**Mẹo nhỏ:** Nếu bạn muốn trang `index.php` này chỉ Admin mới thấy, còn người lạ vào vẫn bị redirect, bạn có thể thêm một dòng check ở đầu file `index.php`:
```php
if (!is_user_logged_in()) {
    wp_redirect('https://your-laravel-site.com');
    exit;
}
```

Dàn "NCC" của bạn giờ đã thực sự có một cái **"Control Center"** cực xịn rồi đấy. Bạn thấy giao diện bảng điều khiển đơn giản này có giúp team 10 người của bạn thao tác nhanh hơn không?