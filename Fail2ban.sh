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

# 创建自定义jail配置
JAIL_FILE="/etc/fail2ban/jail.d/sshd.local"
if [ -e "$JAIL_FILE" ]; then
    rm -f "$JAIL_FILE" || exit_with_error "删除现有文件失败"
fi
read -p "请输入SSH端口号：" SSH_PORT
echo -e "[sshd]\nenabled = true\nport = $SSH_PORT\nfilter = sshd\nlogpath = /var/log/auth.log\nmaxretry = 3\nfindtime = 60\nbantime = 3600" | sudo tee -a "$JAIL_FILE" || exit_with_error "创建 sshd.local 失败"

echo "Fail2ban 安装和配置成功完成，脚本正在删除..."
echo "默认在1min内允许尝试3次，失败则封禁1h"
echo "如需修改，请配置$JAIL_FILE"

# 重启fail2ban
systemctl restart fail2ban || exit_with_error "重启 fail2ban 失败"
rm "$0"