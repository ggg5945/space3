# 使用官方的 3X-UI v2.8.1 镜像作为基础镜像
# FROM ghcr.io/mhsanaei/3x-ui:v2.8.1@sha256:b4d2f43a9df30db91b3486e618f93c92639bf2065302d0cc4bcd9808802fb32a
# 更新
# FROM ghcr.io/mhsanaei/3x-ui:v2.8.2
FROM ghcr.io/mhsanaei/3x-ui:v2.8.4

# 安装 Nginx（使用 apk，适配 Alpine Linux）
RUN apk update && apk add --no-cache nginx && rm -rf /var/cache/apk/*

# 设置工作目录
WORKDIR /app

# 暴露 Nginx 的端口（Hugging Face Spaces app_port）
EXPOSE 2054
EXPOSE 2053

# 设置环境变量，确保 3X-UI 使用内部端口
ENV XUI_PORT=2053
ENV XRAY_VMESS_AEAD_FORCED=false
ENV XUI_ENABLE_FAIL2BAN=false

# 初始化数据库和 Xray 配置文件目录
RUN mkdir -p /data/x-ui/ && \
    touch /data/x-ui/x-ui.db && \
    mkdir -p /data/log/ && \
    mkdir -p /data/tmp/ && \
    mkdir -p /app/bin/ && \
    touch /app/bin/config.json && \
    chmod 777 -R /data/x-ui/ && \
    chmod 777 -R /data/log/ && \
    chmod 777 -R /data/tmp/ && \
    chmod 777 -R /app/bin/ && \
    chmod 777 -R /var/lib/nginx/ && \
    chmod 777 -R /var/log/nginx/

# 创建符号链接，确保 3X-UI 访问正确路径
RUN ln -s /data/x-ui /etc/x-ui

# 创建静态页面目录
RUN mkdir -p /var/www/html

# 复制静态页面
COPY index.html /var/www/html/index.html

# 复制 Nginx 配置文件到 Alpine 正确路径
COPY nginxAll.conf /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/http.d/default.conf

# 添加启动脚本
COPY entrypoint.sh /app/DockerEntrypoint.sh
RUN chmod +x /app/DockerEntrypoint.sh

# 挂载卷以持久化数据
# VOLUME ["/data/x-ui/", "/root/cert/", "/data/log/", "/data/tmp/", "/var/lib/nginx/"]

RUN mkdir -p /data/tmp/ && chmod 777 -R /data/tmp/

# 使用启动脚本运行 3X-UI 和 Nginx
CMD ["/app/DockerEntrypoint.sh"]