#!/bin/bash

echo "选择要执行的操作:"
options=("修改用户名" "修改密码" "修改SSH连接端口" "退出")
select choice in "${options[@]}"; do
    case $REPLY in
        1)
            read -p "输入新的用户名: " new_username
            sudo usermod -l $new_username old_username
            echo "用户名已修改为 $new_username"
            ;;
        2)
            read -s -p "输入新的密码: " new_password
            sudo passwd $USER
            echo "密码已修改"
            ;;
        3)
            read -p "输入新的SSH连接端口: " new_ssh_port
            sudo sed -i "s/Port [0-9]*/Port $new_ssh_port/" /etc/ssh/sshd_config
            sudo service ssh restart
            echo "SSH连接端口已修改为 $new_ssh_port"
            ;;
        4)
            echo "退出脚本"
            break
            ;;
        *)
            echo "无效的选择"
            ;;
    esac
done
