1. Ý nghĩa cái tên
Hồi xưa, /etc viết tắt của "et cetera" (nghĩa là "những thứ khác..."), vì lúc đó người ta chưa biết nhét các file linh tinh vào đâu. Nhưng ngày nay, nó được định nghĩa lại là "Editable Text Configuration" (Cấu hình văn bản có thể chỉnh sửa).

2. Chức năng chính: Chứa file cấu hình
Hầu hết các file trong /etc là file văn bản (.conf, .ini, hoặc file không đuôi). Bạn có thể mở chúng bằng nano, vi để thay đổi cách hệ thống hoặc phần mềm hoạt động.

Các file quan trọng bạn hay gặp:

/etc/passwd & /etc/shadow: Quản lý thông tin user và mật khẩu (đã mã hóa).

/etc/hostname: Lưu tên máy tính của bạn.

/etc/network/ hoặc /etc/resolv.conf: Cấu hình mạng và DNS (nơi bạn fix lỗi IPv4 lúc nãy).

/etc/hosts: Giống như một cuốn danh bạ IP nội bộ.

/etc/sysctl.conf: Nơi cấu hình các tham số kernel (như cái ip_forward mà bạn vừa làm).

3. Phân biệt với các thư mục khác
Để hiểu rõ hơn, hãy nhìn vào sự khác biệt này:

/bin hoặc /usr/bin: Chứa "phần xác" (mã chương trình để chạy).

/etc: Chứa "phần hồn" (quy định chương trình đó chạy như thế nào).

/var: Chứa dữ liệu thay đổi liên tục (logs, database).

4. Đặc điểm riêng trên Alpine Linux
Vì bạn đang dùng Alpine, thư mục /etc có một vài điểm "đặc sản":

/etc/apk/: Chứa cấu hình của trình quản lý gói apk (nơi khai báo các mirror để tải phần mềm).

/etc/init.d/: Chứa các script khởi động của OpenRC (tương đương với systemd trên Ubuntu).

/etc/local.d/: Nếu bạn muốn chạy một lệnh nào đó lúc máy vừa boot xong (như cái lệnh dockerd của bạn), bạn có thể ném script vào đây.

5. Quy tắc vàng khi đụng vào /etc
Quyền Root: Chỉ có user root mới có quyền sửa file trong này.

Backup trước khi sửa: Vì đây là file hệ thống, chỉ cần gõ nhầm một dấu chấm, máy có thể không boot được hoặc mất mạng.

Kinh nghiệm: Luôn chạy cp /etc/file.conf /etc/file.conf.bak trước khi chỉnh sửa.