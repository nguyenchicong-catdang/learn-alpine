docker exec php-alpine-ncc apk add --no-cache php83-mbstring

docker restart php-alpine-ncc

# Biến cấu hình
ADMINER_URL = https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2-en.php
ADMINER_FILE = $(PATH_PHP)/html/adminer.php

php-setup-adminer:
	@echo "--- Dang thiet lap Adminer ---"
	# Tao thu muc html neu chua co
	mkdir -p $(PATH_PHP)/html
	# Tai file Adminer ve va doi ten cho de truy cap
	curl -L $(ADMINER_URL) -o $(ADMINER_FILE)
	@echo "--- Tai xong Adminer tai: $(ADMINER_FILE) ---"
	@echo "--- Truy cap: http://localhost:8888/adminer.php ---"

    # Dùng wget (đơn giản hơn một chút)
wget $(ADMINER_URL) -O $(ADMINER_FILE)

curl -L $(ADMINER_URL) -o $(ADMINER_FILE)
-L (hoặc --location) — "Bám đuổi mục tiêu"
-o (hoặc --output) — "Đặt tên cho thành phẩm"