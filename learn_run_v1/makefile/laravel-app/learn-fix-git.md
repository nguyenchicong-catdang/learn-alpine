# apk add --no-cache git openssh-client

apk add --no-cache git openssh-client

# Cách truyền SSH Key từ máy ngoài vào (SSH Agent Forwarding)

Bước A: Trên máy thật (Windows/WSL của bạn)
Mở PowerShell hoặc terminal máy thật và chạy các lệnh:

Kiểm tra xem SSH Agent đã chạy chưa:

PowerShell

Get-Service ssh-agent | Set-Service -StartupType Automatic

Start-Service ssh-agent

Thêm SSH key của bạn vào agent:

Bash
ssh-add path/to/your/id_rsa

Bước B: Cấu hình VS Code (Remote Container)

Mở file devcontainer.json (nếu bạn dùng Dev Containers) hoặc kiểm tra cài đặt của Remote - Containers.

Đảm bảo option "Forward SSH Agent" được bật (thường nó tự động bật mặc định).

Bước C: Kiểm tra bên trong Container
Trong terminal của container (cái hình bạn gửi), gõ lệnh này:

Bash
echo $SSH_AUTH_SOCK

Cách "NCC" (Dùng Volume Mount) - Nếu cách trên quá phức tạp

services:
  laravel-app:
    volumes:
      - ~/.ssh:/root/.ssh:ro  # Mount quyền chỉ đọc (ro) để an toàn