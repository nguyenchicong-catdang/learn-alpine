# Tại sao không nên dùng wp_redirect cho nút View

Vấn đề nằm ở chỗ lệnh `wp_redirect` của PHP là lệnh ở phía **Server-side**. Khi server gửi lệnh này, trình duyệt sẽ hiểu là: "Bỏ trang hiện tại đi, nạp trang mới vào". Nó hoạt động giống như việc bạn gõ địa chỉ mới vào thanh URL vậy, nên không thể mở tab mới được.

Để giải quyết câu chuyện: **"Click vào nút View -> Mở tab mới dẫn sang Laravel -> Tab cũ WordPress vẫn còn đó"**, bạn có 3 phương án để "ép" WordPress theo ý mình:

### 1. Dùng Filter để thêm `target="_blank"` (Cách "sạch" nhất)
WordPress có các Filter cho phép can thiệp vào thuộc tính của link trong Admin Bar (thanh công cụ phía trên) và danh sách bài viết.

Bạn thêm đoạn này vào `functions.php`:

```php
// Thêm target="_blank" cho tất cả các link "View" trong Admin Bar
add_action('admin_bar_menu', function($wp_admin_bar) {
    $nodes = $wp_admin_bar->get_nodes();
    foreach ($nodes as $node) {
        // Tìm các node có liên quan đến việc "Xem" (view, view-site, view-post)
        if (strpos($node->id, 'view') !== false) {
            $node->meta['target'] = '_blank';
            $wp_admin_bar->add_node($node);
        }
    }
}, 999);

// Thêm target="_blank" cho link "View" trong danh sách bài viết (Row Actions)
add_filter('post_row_actions', function($actions, $post) {
    if (isset($actions['view'])) {
        $actions['view'] = str_replace('<a ', '<a target="_blank" ', $actions['view']);
    }
    return $actions;
}, 10, 2);
```

### 2. Dùng Script để "ép" Admin (Cách triệt để)
Vì trang soạn thảo (Gutenberg) hoặc danh sách bài viết là một ứng dụng JavaScript khá phức tạp, đôi khi Filter PHP không ăn hết các nút. Bạn có thể dùng một đoạn script nhỏ để ép mọi link trỏ về Laravel phải mở tab mới.

```php
add_action('admin_footer', function() {
    ?>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Bất cứ link nào chứa domain Laravel thì cho mở tab mới
        document.body.addEventListener('click', function(e) {
            let link = e.target.closest('a');
            if (link && link.href.includes('your-laravel-site.com')) {
                link.setAttribute('target', '_blank');
            }
        });
    });
    </script>
    <?php
});
```

### 3. Tại sao không nên dùng `wp_redirect` cho nút View?
Nếu bạn dùng `wp_redirect` trong `template_redirect`, nó sẽ biến WordPress thành một cái "trạm trung chuyển".
* **Kịch bản:** Bạn nhấn View -> WP load (tốn RAM/CPU) -> WP gửi lệnh Redirect -> Trình duyệt đóng WP lại -> Sang Laravel.
* **Hệ quả:** Bạn mất luôn tab quản trị, muốn sửa tiếp lại phải nhấn Back hoặc gõ lại `/wp-admin`.

---

### Giải pháp tổng lực cho dàn "NCC" (Kết hợp cả link & redirect)

Để trải nghiệm "phê" nhất, bạn nên kết hợp như sau:
1. **Dùng Filter (Cách 1):** Để khi bạn **chủ động** nhấn nút View, nó mở tab mới sang Laravel ngay lập tức (không đợi WP load rồi mới redirect).
2. **Dùng Redirect (Code cũ của bạn):** Để làm "bảo hiểm". Nếu lỡ có ai đó gõ link WP trực tiếp, nó vẫn đẩy sang Laravel.

**Lưu ý về ảnh `image_f845a5.png`:**
Trong ảnh bạn gửi, cái thanh Admin Bar màu đen phía trên có nút **"Edit Post"**. Khi bạn dùng Filter thêm `target="_blank"`, nút **"View Post"** trên thanh đó cũng sẽ tự động mở tab mới. Bạn có thể vừa mở tab Laravel để xem UI, vừa giữ tab WP để chỉnh sửa nội dung "real-time" (nếu Laravel của bạn có cơ chế auto-refresh hoặc bạn nhấn F5).

Bạn thấy phương án dùng Filter can thiệp trực tiếp vào thẻ `<a>` để thêm `target="_blank"` có giải quyết được sự phiền phức khi bị mất trang WP không?