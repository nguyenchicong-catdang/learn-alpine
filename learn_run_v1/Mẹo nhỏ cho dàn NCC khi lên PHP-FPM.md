# Mẹo nhỏ cho dàn "NCC" khi lên PHP-FPM:

Mẹo nhỏ cho dàn "NCC" khi lên PHP-FPM:
Nếu bạn muốn tối ưu RAM đến mức "khô máu" trên Alpine, trong file php-fpm.conf, hãy chỉnh:

Ini, TOML
pm = ondemand
pm.max_children = 5
pm.process_idle_timeout = 10s
ondemand: Nghĩa là khi nào có người truy cập web thì PHP mới sinh ra tiến trình. Không có ai thì nó "ngủ", RAM sẽ cực thấp.

max_children: Giới hạn số lượng "con" để tránh việc traffic đột ngột làm tràn RAM của máy Lab.

Bạn định khi nào thì "hợp nhất" con WP-CLI này vào PHP-FPM? Hay bạn định giữ một container riêng chỉ để chạy các lệnh quản trị bằng tay cho nó sạch?