#!/bin/bash

# 设置备份和压缩相关的变量
source_dir="/root/data/docker_data"   # 需保存文件夹
backup_dir="/root/data/docker_data_backup"   # 备份存放文件夹
backup_gz="/root/data"   # 压缩包存放文件夹
backup_filename="docker_data_$(date +\%Y\%m\%d).tar.gz"   # 压缩包命名规则
max_backups=3                     #压缩包最大备份数量
logpath="/var/log/backup.log"     #日志存放文件夹


# 设置目标服务器接受文件路径
#target_server=" root@your.server.com " #目标服务器地址
#target_port="*** "                     #目标服务器SSH端口号
target_path="/root/data"               #目标服务器存放文件位置（需要提前建好文件夹）

#字体颜色定义
orange='\033[33m'
green='\033[32m'
plain='\033[0m'

# 备份文件
function perform_backup {
    echo "备份启动"

    # 如果 backup_dir 不存在，则创建
    mkdir -p "$backup_dir"

    # 复制 source_dir 到 backup_dir，覆盖已存在的文件
    rsync -av --delete "$source_dir/" "$backup_dir/"   

    # 创建整体备份文件
    tar -czf "$backup_gz/$backup_filename" -C "$backup_gz" "$(basename "$backup_dir")"

    # 删除备份文件夹
    rm -rf "$backup_dir/" 

    # 清理多余备份文件
    cleanup_backups

    echo "${green}数据备份完成，请查看/root/data文件夹${plain}"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - 备份完成">> "$logpath"
}

# 清理多余备份文件
function cleanup_backups {
    local backups=($(find "$backup_gz" -maxdepth 1 -type f -name 'docker_data_*.tar.gz' -printf '%T@ %p\n' | sort -n | head -n -$max_backups | awk '{print $2}'))
    for old_backup in "${backups[@]}"; do
        rm -f "$old_backup"
        echo "删除多余备份: $old_backup"
        echo "$(date +'%Y-%m-%d %H:%M:%S') - 删除多余备份: $old_backup">> "$logpath"
    done
}

# 传输备份文件到目标服务器
function transfer_to_server {
    echo "传输启动"
    read -p  "请输入目标服务器地址（${green}用户名@IP${plain}）: " target_server
    read -p  "       请输入目标服务器${green}SSH端口号${plain}: " target_port
    read -p  "     请输入远程服务器的${green}SSH连接密码${plain}: " remote_password

    # 使用 sshpass 执行 scp 命令
    echo "查找最新备份文件中，请耐心等待..."
    latest_backup=$(find "$backup_gz" -type f -name 'docker_data_*.tar.gz' -printf '%T@ %p\n' | sort -n | tail -n 1 | awk '{print $2}')
    echo "数据传输中，请耐心等待..."
    sshpass -p "$remote_password" scp -P "$target_port" "$latest_backup" "$target_server:$target_path"
    if [ $? -eq 0 ]; then
        echo "${green}数据传输完成，请检查目标服务器相应路径！${plain}"
        echo "$(date +'%Y-%m-%d %H:%M:%S') - 传输完成" >> "$logpath"
    else
        echo "${green}传输失败，请检查输入信息是否正确！${plain}"
        read -p $'选择操作：\n 0.退出脚本 \n 1.重新进行传输 \n 请输入：[0/1]: ' choice

        case "$choice" in
            1)
                transfer_to_server
                ;;
            0)
                echo "脚本已退出"
                exit 1
                ;;
            *)
                echo "无效的选项，脚本已退出"
                exit 1
                ;;
        esac
    fi
}

# 根据参数执行相应操作
case "$1" in
    "b")
        perform_backup
        ;;
    "t")
        transfer_to_server
        ;;
    "s")
        perform_backup
        transfer_to_server
        echo "$(date +'%Y-%m-%d %H:%M:%S') - 备份与传输完成">> "$logpath"
        ;;
    *)
        echo "输入 ->  ${green}sudo $0 [b|t|s]${plain} <- 运行脚本"
        echo "如 ${green}sudo $0 b${plain} 表示备份文件夹"
        echo "b是备份,t是迁移,s是备份+迁移"
        echo "迁移需要目标服务器：用户名@IP、SSH连接端口号、密码"
        exit 1
        ;;
esac
