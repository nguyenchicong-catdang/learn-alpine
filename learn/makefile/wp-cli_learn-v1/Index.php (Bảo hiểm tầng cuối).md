# Index.php (Bảo hiểm tầng cuối)

Nhìn cái ảnh danh sách Post của bạn, mình hiểu ý bạn rồi: **"Nếu can thiệp bằng index.php (tầng frontend) thì chỉ giải quyết được lúc nó đã nhảy ra ngoài, còn cái nút View trong Admin kia nó vẫn 'cướp' mất cái tab đang làm việc."**

Để can thiệp vào cái nút **"View"** (như trong ảnh `image_f8ae69.png`) mà không làm mất trang Admin, bạn nên dùng kết hợp giữa việc **đổi URL** và **ép mở tab mới** ngay tại tầng Admin.

Dưới đây là đoạn code "tất cả trong một" để bạn xử lý triệt để các nút View trong WordPress Admin:

### 1. Code xử lý nút "View" mở tab mới
Bạn cho đoạn này vào `functions.php`. Nó sẽ can thiệp trực tiếp vào cái danh sách post bạn đang xem trong ảnh:

```php
/**
 * 1. Thay đổi URL nút "View" trỏ sang Laravel và ép mở Tab mới
 */
add_filter('post_row_actions', function($actions, $post) {
    if (isset($actions['view'])) {
        // Domain Laravel của bạn
        $laravel_domain = 'https://your-laravel-site.com';
        $new_url = $laravel_domain . '/' . $post->post_name;

        // Thay URL cũ bằng URL mới và thêm target="_blank"
        $actions['view'] = str_replace(
            ['href="', '<a '], 
            ['href="' . $new_url, '<a target="_blank" '], 
            $actions['view']
        );
    }
    return $actions;
}, 10, 2);

/**
 * 2. Xử lý tương tự cho nút "View" trên Admin Bar (Thanh đen phía trên)
 */
add_action('admin_bar_menu', function($wp_admin_bar) {
    $all_nodes = $wp_admin_bar->get_nodes();
    foreach ($all_nodes as $node) {
        if (strpos($node->id, 'view') !== false) {
            $node->meta['target'] = '_blank'; // Ép mở tab mới
            // Nếu muốn đổi link ở đây luôn thì:
            // $node->href = 'https://your-laravel-site.com' . parse_url($node->href, PHP_URL_PATH);
            $wp_admin_bar->add_node($node);
        }
    }
}, 999);
```

### 2. Tại sao không nên chỉ dùng Script chuyển trang ở `index.php`?
Nếu bạn chỉ dùng script chuyển trang (redirect) ở file `index.php` của theme:
1. Trình duyệt vẫn sẽ tải trang WP hiện tại (tốn tài nguyên).
2. Nó sẽ redirect **trên chính tab đó**, làm mất trang Admin.
3. Người dùng (team bạn) sẽ cực kỳ khó chịu vì cứ nhấn View là phải "lội ngược dòng" quay lại WP-Admin.

### 3. Giải pháp "Khô máu" cho cái Index.php (Bảo hiểm tầng cuối)
Để đề phòng trường hợp bạn click vào đâu đó mà code trên chưa bắt được, hãy biến cái `index.php` của theme thành một cái "biển báo" thay vì một script chuyển hướng tự động:

```php
// Trong theme-cua-ban/index.php
<?php
$laravel_url = 'https://your-laravel-site.com' . $_SERVER['REQUEST_URI'];
?>
<!DOCTYPE html>
<html>
<head>
    <title>Redirecting to Frontend...</title>
</head>
<body>
    <p>Đang chuyển hướng sang Laravel tại: <a href="<?php echo $laravel_url; ?>"><?php echo $laravel_url; ?></a></p>
    <script>
        // Chỉ tự động chuyển nếu không phải đang ở trong iframe (đề phòng WP Preview)
        if (window.self === window.top) {
            window.location.href = "<?php echo $laravel_url; ?>";
        }
    </script>
</body>
</html>
```

---

### Tổng kết quy trình cho dàn NCC:
* **Admin tầng PHP (Code 1):** Sửa link và thêm `target="_blank"`. Khi click vào nút View trong ảnh của bạn, nó sẽ **bắn sang tab mới** dẫn thẳng tới Laravel. Tab cũ WP vẫn giữ nguyên để bạn sửa tiếp.
* **Frontend tầng PHP (Index.php):** Làm lớp bảo vệ cuối cùng. Nếu ai đó gõ link WP trực tiếp, nó sẽ đẩy đi.

Cách này giúp bạn giữ được cái "vibe" làm việc liên tục: **Viết ở WP -> Click View -> Xem ở tab bên cạnh -> Quay lại WP viết tiếp.** Bạn thấy việc ép `target="_blank"` ngay từ danh sách Post này có "lành" hơn cho workflow của bạn không?