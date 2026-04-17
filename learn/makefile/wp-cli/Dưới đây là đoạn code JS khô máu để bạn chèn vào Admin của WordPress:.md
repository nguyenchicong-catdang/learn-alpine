# Dưới đây là đoạn code JS "khô máu" để bạn chèn vào Admin của WordPress:

Cách tiếp cận dùng **JavaScript (JS)** để "đánh chặn" (intercept) toàn bộ thẻ `<a>` là một giải pháp cực kỳ thông minh và "lành" cho dân Dev. Thay vì phải đi sửa từng Filter trong PHP vốn rất dễ sót, bạn dùng JS để quản lý tập trung ngay tại trình duyệt của người dùng.

Dưới đây là đoạn code JS "khô máu" để bạn chèn vào Admin của WordPress:

### 1. Code JS đánh chặn toàn bộ thẻ `<a>`
Bạn thêm đoạn này vào file `functions.php` để nó nhúng vào trang quản trị:

```php
add_action('admin_footer', function() {
    ?>
    <script>
    (function() {
        const laravelDomain = 'https://your-laravel-site.com';

        document.addEventListener('click', function(e) {
            // 1. Tìm thẻ <a> gần nhất với vị trí click
            const anchor = e.target.closest('a');

            // 2. Kiểm tra điều kiện: có thẻ <a>, có href, và KHÔNG chứa 'wp-admin'
            if (anchor && anchor.href && !anchor.href.includes('wp-admin')) {
                const url = new URL(anchor.href);

                // 3. Nếu link trỏ đến trang chủ hoặc bài viết (không phải login/logout/ajax)
                if (!url.search.includes('action=logout') && !url.pathname.includes('wp-login')) {
                    
                    // Ngăn chặn trình duyệt mở link theo cách mặc định
                    e.preventDefault();

                    // 4. Tạo URL mới trỏ sang Laravel
                    // Giữ nguyên pathname (vd: /test-bai-viet/) và query (vd: ?preview=true)
                    const newLaravelUrl = laravelDomain + url.pathname + url.search;

                    // 5. Ép mở sang TAB MỚI
                    window.open(newLaravelUrl, '_blank');
                }
            }
        }, true); // Sử dụng Capture phase để đánh chặn sớm nhất có thể
    })();
    </script>
    <?php
});
```

---

### 2. Tại sao cách này lại "vô đối" cho Case của bạn?

* **Xử lý được ảnh `image_f8c18c.png`:** Cái nút "Preview" trong ảnh của bạn thực chất là một thẻ `<a>`. JS sẽ bắt được cái `href` đó, thấy nó không có `wp-admin`, nó sẽ lấy phần `/test/?preview=true` rồi đập sang tab mới của Laravel.
* **Không làm mất trang Admin:** Vì dùng `e.preventDefault()` và `window.open(..., '_blank')`, tab WP hiện tại của bạn sẽ đứng yên, không hề bị tải lại hay chuyển trang.
* **Bao phủ toàn diện:** Bất kể nút "View" ở danh sách Post, nút "Preview" trong Gutenberg, hay nút "View Site" trên Admin Bar, hễ không dính tới trang quản trị (`wp-admin`) là nó "đá" sang Laravel hết.

### 3. Lưu ý nhỏ để "mượt" hơn
Trong ảnh của bạn, link có dạng `http://127.0.0.1:8080/test/?preview=true`. 
* Nếu phía Laravel của bạn nhận request này, bạn cần code bên Laravel để hiểu cái tham số `?preview=true` (thường là để gọi API lấy bản nháp - draft thay vì bản đã publish).

### 4. Cách kiểm tra nhanh
Sau khi chèn code, bạn F5 trang Admin, mở **Inspect Element (F12)** -> tab **Console**. Thử click vào nút Preview. Nếu nó bật tab mới sang domain Laravel bạn đã cấu hình là bạn đã thành công "hack" được luồng làm việc của WordPress rồi đấy.

Dàn **NCC** của bạn giờ đã có một bộ UI quản trị cực kỳ chuyên nghiệp: **Back-end một nơi, Front-end một nẻo, nhưng bấm nút là kết nối ngay lập tức.** Bạn có thấy cách dùng JS này "nhàn" hơn việc đi mò từng Filter của WP không?