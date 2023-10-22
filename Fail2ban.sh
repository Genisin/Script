#!/bin/bash

# 函数：显示错误消息并以错误代码退出
exit_with_error() {
    echo "错误：$1"
    exit 1
}

# 更新系统并安装fail2ban
apt update -y || exit_with_error "运行 'apt update' 失败"
apt install -y fail2ban || exit_with_error "安装 fail2ban 失败"

# 启动和启用fail2ban
systemctl start fail2ban || exit_with_error "启动 fail2ban 失败"
systemctl enable fail2ban || exit_with_error "启用 fail2ban 失败"

# 创建自定义jail配置
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local || exit_with_error "创建 jail.local 失败"
rm -rf /etc/fail2ban/jail.d/* || exit_with_error "移除 jail.d 内容失败"
echo -e "[sshd]\nenabled = true\nmode = normal\nbackend = systemd" | sudo tee -a /etc/fail2ban/jail.d/sshd.local || exit_with_error "创建 sshd.local 失败"

# 重启fail2ban
systemctl restart fail2ban || exit_with_error "重启 fail2ban 失败"

echo "Fail2ban 安装和配置成功完成，脚本正在删除..."
rm "$0"