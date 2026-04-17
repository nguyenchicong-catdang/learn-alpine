> apk add --no-cache git openssh

PowerShell
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent

ssh-keygen -t ed25519 -C "nguyenchicong.catdang@gmail.com"

# Nạp file private key (file không có đuôi .pub)
ssh-add C:\Users\dell\.ssh\id_ed25519

notepad C:\Users\dell\.ssh\id_ed25519.pub

ssh -T git@github.com

echo $SSH_AUTH_SOCK

Nhấn Ctrl + , (Settings).

# Tự động kết nối SSH Agent từ Windows sang WSL
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
if [ ! -S $SSH_AUTH_SOCK ]; then
    # Kiểm tra nếu ssh-agent trên Windows đang chạy (thông qua lệnh ssh-add.exe)
    if ss -lnpt | grep -q 127.0.0.1:ssh-agent-port; then
         # Lệnh này tùy thuộc vào việc bạn dùng công cụ relay nào
         echo "SSH Agent bridge is missing"
    fi
fi


export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock


ssh-add -l

# # 1. Cài đặt các công cụ cần thiết (nếu chưa có)
apk add --no-cache git openssh-client

# 2. Tạo thư mục .ssh và phân quyền đúng chuẩn
mkdir -p /root/.ssh
chmod 700 /root/.ssh

vi /root/.ssh/id_ed25519

chmod 600 /root/.ssh/id_ed25519

ssh -T git@github.com