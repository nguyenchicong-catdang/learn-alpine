# fix IPv4 forwarding is disabled. Networking will not work.

sysctl -w net.ipv4.ip_forward=1

sysctl net.ipv4.ip_forward
# Nó phải hiện ra: net.ipv4.ip_forward = 1

echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/docker.conf

/etc/sysctl.d/

docker.conf

vi /etc/sysctl.d/docker.conf

net.ipv4.ip_forward = 1

sysctl -p /etc/sysctl.conf
# Hoặc nếu bạn làm theo cách 2:
sysctl --system

sysctl net.ipv4.ip_forward

docker start nginx-alpine-ncc php-alpine-ncc mariadb-alpine-ncc wp-cli-alpine-ncc