# Thay đổi Permalink

Đúng là "nỗi đau" của dân làm Headless! Quản trị viên đăng bài xong rất hay có thói quen nhấn vào nút **"View Post"** hoặc biểu tượng cái mắt để xem thành quả. Nếu bạn để mặc định, nó sẽ dẫn về URL của WordPress (vốn đã bị bạn chặn hoặc redirect), khiến trải nghiệm rất khó chịu.

Để giải quyết bài toán này "khô máu" và chuyên nghiệp, bạn cần thực hiện 2 bước:

### 1. Sửa URL của nút "View Post" (Thay đổi Permalink)
Thay vì để WordPress tự sinh link, bạn sẽ dùng Filter để ép nó trỏ về phía Laravel. Bạn chỉ cần lấy cái `slug` (đường dẫn bài viết) rồi ghép nó vào domain của Laravel.

Thêm đoạn này vào `functions.php`:

```php
add_filter('preview_post_link', 'ncc_headless_preview_link');
add_filter('post_link', 'ncc_headless_post_link', 10, 2);

// 1. Sửa link xem trước (Preview)
function ncc_headless_preview_link($link) {
    return 'https://your-laravel-site.com/preview?id=' . get_the_ID();
}

// 2. Sửa link bài viết chính thức (để các nút View trỏ đúng chỗ)
function ncc_headless_post_link($permalink, $post) {
    if ($post->post_status == 'publish') {
        // Lấy slug của bài viết và ghép vào domain Laravel
        return 'https://your-laravel-site.com/posts/' . $post->post_name;
    }
    return $permalink;
}
```

### 2. Logic Redirect thông minh (Xử lý req path)
Nếu bạn lỡ tay click vào một cái link cũ hoặc muốn chắc chắn 100% không bao giờ bị "kẹt" lại ở phía WP, hãy nâng cấp đoạn redirect lúc nãy của bạn bằng cách **ghép đường dẫn**:

```php
add_action('template_redirect', function() {
    // Nếu là Admin hoặc API thì cho qua
    if (is_admin() || (defined('REST_REQUEST') && REST_REQUEST)) return;

    // Lấy cái path hiện tại (ví dụ: /test-bai-viet/)
    $path = $_SERVER['REQUEST_URI'];
    
    // Đẩy sang Laravel kèm theo path đó
    $laravel_url = 'https://your-laravel-site.com' . $path;

    wp_redirect($laravel_url, 301);
    exit;
});
```

### Tại sao làm vậy lại "Sướng"?
* **Nút View hoạt động chuẩn:** Khi bạn di chuột vào nút "View" (như trong ảnh `image_f84286.png`), bạn sẽ thấy ở góc màn hình link đã đổi thành `laravel-site.com/test/`. Click một phát là sang thẳng giao diện đẹp của Laravel luôn.
* **Xử lý được cả bài viết mới:** Nhờ dùng `$post->post_name`, dù bạn đặt tiêu đề là gì, nó cũng tự động map đúng sang Laravel.

### Mẹo cho hình ảnh `image_f8416a.png` (Gutenberg)
Trong trình soạn thảo Gutenberg, nút "Preview" đôi khi hơi "cứng đầu". Nếu bạn muốn nó mở ra tab mới trỏ về Laravel để kiểm tra UI ngay khi đang viết, bạn có thể cài thêm một plugin nhỏ tên là **"Headless Mode"** hoặc dùng script trên để ghi đè.

**Lưu ý nhỏ:** Phía Laravel của bạn cũng phải có route tương ứng (ví dụ: `/posts/{slug}`) để tiếp nhận cái request này nhé.

Dàn "NCC" của bạn giờ đã thực sự trở thành một cái "Content Engine" giấu mặt rồi đấy. Admin chỉ việc đăng bài, nhấn View là thấy ngay kết quả trên Laravel. Bạn thấy việc sửa link trực tiếp từ Filter này có tiện hơn là cứ phải copy-paste link sang Laravel không?