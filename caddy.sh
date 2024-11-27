#!/bin/bash

# Caddy 安装脚本 for Fedora, RHEL/CentOS, Debian/Ubuntu
# 检查是否已安装 Caddy
if command -v caddy &> /dev/null; then
    echo "Caddy 已安装，版本信息："
    caddy version
    exit 0
fi

# 获取系统信息
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
fi

case $OS in
    debian|ubuntu)
        echo "检测到 Debian/Ubuntu 系统..."
        apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
        curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
        apt update
        apt install -y caddy
        ;;
    rhel|centos)
        echo "检测到 RHEL/CentOS 系统..."
        if [ "$VERSION_ID" -ge 8 ]; then
            echo "使用 dnf 安装 Caddy..."
            dnf install -y 'dnf-command(copr)'
            dnf copr enable @caddy/caddy -y
            dnf install -y caddy
        else
            echo "使用 yum 安装 Caddy..."
            yum install -y yum-plugin-copr
            yum copr enable @caddy/caddy -y
            yum install -y caddy
        fi
        ;;
    *)
        echo "不支持的操作系统"
        exit 1
        ;;
esac

echo "Caddy 安装完成！"