Đúng là "biển học vô bờ", nếu môi trường Docker đang lỗi nhân (Kernel) quá sâu thì tạm gác nó lại, tập trung vào **Makefile** là một hướng đi cực kỳ khôn ngoan. Makefile sẽ giúp bạn đóng gói mọi quy trình phức tạp thành các lệnh siêu ngắn (như `make build`, `make test`).

Dưới đây là cách bạn giải quyết câu chuyện: **Dùng Makefile để quản lý** và **Cách "lách luật" để test/xem trên trình duyệt** khi Docker bị "què" mạng.

---

### 1. Makefile mẫu cho dân Dev
Vì bạn đang ở `/home/git/learn-alpine`, hãy tạo một file tên là `Makefile` với nội dung sau:

```makefile
# Định nghĩa biến
IMAGE_NAME = my-alpine-app
CONTAINER_NAME = test-app

# Lệnh build image
build:
	docker build -t $(IMAGE_NAME) .

# Lệnh chạy thử (vì máy bạn lỗi mạng nên ta dùng --net=host)
run:
	-docker rm -f $(CONTAINER_NAME)
	docker run -d --name $(CONTAINER_NAME) --net=host $(IMAGE_NAME)

# Lệnh kiểm tra log xem app có lỗi không
logs:
	docker logs -f $(CONTAINER_NAME)

# Dọn dẹp
clean:
	docker rm -f $(CONTAINER_NAME)
	docker rmi $(IMAGE_NAME)
```
*(Lưu ý: Trong Makefile, các dòng lệnh phải bắt đầu bằng phím **Tab**, không dùng dấu cách).*

---

### 2. Làm sao để biết Image có chạy không?
Khi không dùng được `-p`, bạn có 2 cách để kiểm tra xem container có đang "sống" và xử lý logic không:

* **Cách 1: Kiểm tra Log (`make logs`)**
  Nếu là app Laravel hay Nginx, xem log xem nó có báo `Started` hay `Listening on port...` không.
* **Cách 2: Chui vào bên trong container (Inspect)**
  ```bash
  docker exec -it test-app sh
  # Sau đó dùng curl (nếu có) để tự gọi chính nó
  curl http://localhost
  ```

---

### 3. Cách VS Code "bắt" Port lên trình duyệt
Đây là "ma thuật" để bạn thấy được kết quả trên Chrome ngay cả khi Docker đang lỗi mạng trên Server/WSL2.

**Dùng tính năng Port Forwarding của VS Code:**
1. Mở VS Code, kết nối vào môi trường bạn đang code (thông qua SSH hoặc WSL).
2. Nhấn tổ hợp phím `` Ctrl + ` `` để mở Terminal.
3. Tìm tab có tên là **Ports** (nằm cạnh tab Terminal/Output).
4. Nhấn **Forward a Port**.
5. Nhập số port mà app bạn đang chạy (ví dụ `80` hoặc `8080`).
6. VS Code sẽ cho bạn một địa chỉ dạng `http://localhost:8080`. Khi bạn bấm vào đó, VS Code sẽ đóng vai trò "đường ống" dẫn thẳng từ cái app đang chạy ẩn sâu trong Docker lên trình duyệt của bạn.



---

### 4. Tại sao cách này "cứu" được bạn?
Sở dĩ dùng `--net=host` (trong Makefile) và Port Forwarding (trong VS Code) hiệu quả là vì:
* **`--net=host`**: Nó không thèm tạo card mạng ảo (thứ đang bị lỗi Kernel), mà nó dùng thẳng IP của máy host.
* **VS Code**: Nó không quan tâm Docker có NAT được port hay không, nó chỉ cần thấy trên máy host đó có một cái port đang mở là nó "túm" lấy và đẩy lên máy tính của bạn.

**Câu hỏi tiếp theo:** Bạn đang viết Dockerfile cho app gì? Laravel hay là một script Bash đơn giản? Để mình chỉ cách viết `make test` cho chuẩn bài luôn.