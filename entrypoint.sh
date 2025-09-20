#!/bin/sh

# Start fail2ban
[ $XUI_ENABLE_FAIL2BAN == "true" ] && fail2ban-client -x start

# Run x-ui
nohup /app/x-ui &

# 使用 -g 'daemon off;' 确保 Nginx 在前台运行，这是 Docker 推荐的方式，因为 Docker 容器需要一个前台进程。
/usr/sbin/nginx -g 'daemon off;'

# sleep 100000
