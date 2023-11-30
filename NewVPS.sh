#!/bin/bash

# 菜单
echo "=========== VPS设置 ============"
echo "1. 更改SSH端口"
echo "2. 重置密码"
echo "3. 添加新用户"
echo "4. 禁止root登录"
echo "5. 重置VPS设置"
echo "6. 下载自用脚本"
echo "0. 退出脚本"
echo "================================"

# 设置默认值为"Y"
read -e -p "请选择要执行的功能: " choice

case $choice in
    1)
        # 更改SSH端口
        current_ssh_port=$(grep -oP '(?<=Port )\d+' /etc/ssh/sshd_config)
        echo "当前SSH端口为: $current_ssh_port"
        read -e -p "是否需要更改SSH端口？(Y/n): " change_port

        if [ "${change_port,,}" != "n" ]; then
            read -e -p "请输入新的SSH端口: " new_ssh_port
            sed -i "s/Port $current_ssh_port/Port $new_ssh_port/" /etc/ssh/sshd_config
            sudo service ssh restart
            echo "SSH端口已更改为: $new_ssh_port"
        else
            echo "未更改SSH端口."
        fi
        ;;
    2)
        # 重置密码
        read -e -p "是否需要重置密码？(Y/n): " reset_password

        if [ "${reset_password,,}" != "n" ]; then
            read -s -p "请输入新密码: " new_password
            echo -e "$new_password\n$new_password" | passwd
            echo "密码已重置."
        else
            echo "未重置密码."
        fi
        ;;
    3)
        # 添加新用户
        read -e -p "是否添加新用户？(Y/n): " add_new_user

        if [ "${add_new_user,,}" != "n" ]; then
            read -e -p "请输入新用户名: " new_username
            read -s -p "请输入新用户密码: " new_user_password
            echo
            useradd -m -s /bin/bash "$new_username"
            echo -e "$new_user_password\n$new_user_password" | passwd "$new_username"
            apt-get update
            apt-get install -y sudo
            usermod -aG sudo "$new_username"
            read -e -p "是否需要临时使用root权限时不输入密码？(Y/n): " no_password_sudo

            if [ "${no_password_sudo,,}" != "n" ]; then
                echo "$new_username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
                echo "已添加NOPASSWD规则."
            else
                echo "未添加NOPASSWD规则."
            fi

            echo "新用户已添加."
        else
            echo "未添加新用户."
        fi
        ;;
    4)
        # 禁止root登录
        read -e -p "是否禁止root登录？(Y/n): " disable_root_login

        if [ "${disable_root_login,,}" != "n" ]; then
            cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
            sed -i 's/PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
            sudo service ssh restart
            echo "已禁止root登录."
        else
            echo "未禁止root登录."
        fi
        ;;
    5)
        # 顺序执行所有功能
        # 1. 更改SSH端口
        current_ssh_port=$(grep -oP '(?<=Port )\d+' /etc/ssh/sshd_config)
        echo "当前SSH端口为: $current_ssh_port"
        read -e -p "是否需要更改SSH端口？(Y/n): " change_port

        if [ "${change_port,,}" != "n" ]; then
            read -e -p "请输入新的SSH端口: " new_ssh_port
            sed -i "s/Port $current_ssh_port/Port $new_ssh_port/" /etc/ssh/sshd_config
            sudo service ssh restart
            echo "SSH端口已更改为: $new_ssh_port"
        else
            echo "未更改SSH端口."
        fi

        # 2. 重置密码
        read -e -p "是否需要重置密码？(Y/n): " reset_password

        if [ "${reset_password,,}" != "n" ]; then
            read -s -p "请输入新密码: " new_password
            echo -e "$new_password\n$new_password" | passwd
            echo "密码已重置."
        else
            echo "未重置密码."
        fi

        # 3. 添加新用户
        read -e -p "是否添加新用户？(Y/n): " add_new_user

        if [ "${add_new_user,,}" != "n" ]; then
            read -e -p "请输入新用户名: " new_username
            read -s -p "请输入新用户密码: " new_user_password
            echo
            useradd -m -s /bin/bash "$new_username"
            echo -e "$new_user_password\n$new_user_password" | passwd "$new_username"
            apt-get update
            apt-get install -y sudo
            usermod -aG sudo "$new_username"
            read -e -p "是否需要临时使用root权限时不输入密码？(Y/n): " no_password_sudo

            if [ "${no_password_sudo,,}" != "n" ]; then
                echo "$new_username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
                echo "已添加NOPASSWD规则."
            else
                echo "未添加NOPASSWD规则."
            fi

            echo "新用户已添加."
        else
            echo "未添加新用户."
        fi

        # 4. 禁止root登录
        read -e -p "是否禁止root登录？(Y/n): " disable_root_login

        if [ "${disable_root_login,,}" != "n" ]; then
            cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
            sed -i 's/PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
            sudo service ssh restart
            echo "已禁止root登录."
        else
            echo "未禁止root登录."
        fi
        ;;

    6)
    echo "=========== 脚本下载 ============"
    echo "1. 容器镜像更新"
    echo "2. 文件备份迁移"
    echo "3. 日志每日清理"
    echo "4. 系统信息查看"
    echo "5. Fail2ban自动设置"
    echo "6. Geo文件自动更新"
    echo "0. 退出脚本"
    echo "================================"

    # 设置默认值为"Y"
    read -e -p "请选择要执行的功能: " script

    case $script in
     1)
        sudo wget https://raw.githubusercontent.com/Genisin/script/main/DockerUpdate/Install.sh && chmod +x Install.sh && sudo ./Install.sh
        ;;
     2)
        sudo wget https://raw.githubusercontent.com/Genisin/script/main/DocumentBackup/Install.sh && chmod +x Install.sh && sudo ./Install.sh 
        ;;
     3)
        sudo wget https://raw.githubusercontent.com/Genisin/script/main/LogClean/Install.sh && chmod +x Install.sh && sudo ./Install.sh
        ;;
     4)
        sudo wget https://raw.githubusercontent.com/Genisin/script/main/SystemInfo/Install.sh && chmod +x Install.sh && sudo ./Install.sh  
        ;;
     5)
        sudo wget https://raw.githubusercontent.com/Genisin/Script/main/Fail2ban.sh && chmod +x Fail2ban.sh && sudo ./Fail2ban.sh  
        ;;
     6)
        sudo wget https://raw.githubusercontent.com/Genisin/script/main/GeoUpdate/Install.sh && chmod +x Install.sh && sudo ./Install.sh 
        ;;
     0)
        # 退出脚本
        echo "脚本已退出."
        exit 0
        ;;
     *)
    ;;
    0)
        # 退出脚本
        echo "脚本已退出."
        exit 0
        ;;
    *)
       
