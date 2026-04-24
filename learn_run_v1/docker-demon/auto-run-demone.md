# learn/docker-demon/auto-run-demone.md

vi /etc/profile.d/profile-auto-run.sh

```sh
#!/bin/sh

# Kiểm tra xem dockerd đã chạy chưa
if ! pgrep -x "dockerd" > /dev/null
then
    echo "Starting Docker daemon..."
    # nohup dockerd > /dev/null 2>&1 &
    # dockerd > /dev/null 2>&1 &
    dockerd --iptables=false --bridge=none --ip-forward=false > /dev/null 2>&1 &
    
    # Đợi một vài giây để daemon khởi động hoàn toàn
    sleep 2
    echo "Docker is ready."
else
    echo "Docker daemon is already running."
fi
```
