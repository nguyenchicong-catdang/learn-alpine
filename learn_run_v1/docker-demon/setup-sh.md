vi ~/.profile

```sh
#!/bin/sh

# Kiểm tra xem dockerd đã chạy chưa
if ! pgrep -x "dockerd" > /dev/null
then
    echo "Starting Docker daemon..."
    # nohup dockerd > /dev/null 2>&1 &
    dockerd > /dev/null 2>&1 &
    
    # Đợi một vài giây để daemon khởi động hoàn toàn
    sleep 2
    echo "Docker is ready."
else
    echo "Docker daemon is already running."
fi
```

. ~/.profile

apk add iptables ip6tables

apk add iptables-legacy

# fix

# 1. Cài đặt các gói cần thiết
apk add iptables-legacy ip6tables-legacy

# 2. Xóa lệnh iptables cũ và link tới bản legacy
rm -f /sbin/iptables /sbin/ip6tables
ln -s /sbin/iptables-legacy /sbin/iptables
ln -s /sbin/ip6tables-legacy /sbin/ip6tables

# 3. Thử chạy lại (không đẩy vào dev/null để xem nó còn báo lỗi không)
dockerd

lsmod | grep ip_tables

modprobe ip_tables
modprobe iptable_nat
modprobe iptable_filter
modprobe br_netfilter
modprobe overlay

# fix run
dockerd --iptables=false --bridge=none --ip-forward=false > /dev/null 2>&1 &