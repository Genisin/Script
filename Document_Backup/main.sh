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

# 备份文件
function perform_backup {
    echo "备份启动"

        # 删除原备份文件
    rm -rf "$backup_dir/"

    # 遍历源目录下的子文件夹
    for subdir in "$source_dir"/*; do
        if [ -d "$subdir" ]; then
            subdirname=$(basename "$subdir")
            backup_subdir="$backup_gz/$subdirname"   # 修改备份存放路径为 $backup_gz
            mkdir -p "$backup_subdir"
            rsync -av --delete "$subdir/" "$backup_subdir/"
        fi
    done

    # 创建整体备份文件
    tar -czf "$backup_gz/$backup_filename" -C "$backup_gz" .

    # 删除备份文件
    rm -rf "$backup_dir/"

    # 清理多余备份文件
    cleanup_backups
    
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
    read -p "请输入目标服务器地址（例如：root@your.server.com）: " target_server
    read -p "请输入目标服务器端口号: " target_port
    read  -p "请输入远程服务器的密码: " remote_password

    # 使用 sshpass 执行 scp 命令
    echo "查找最新备份文件中，请耐心等待..."
    latest_backup=$(find "$backup_gz" -type f -name 'docker_data_*.tar.gz' -printf '%T@ %p\n' | sort -n | tail -n 1 | awk '{print $2}')
    echo "数据传输中，请耐心等待..."
    sshpass -p "$remote_password" scp -P "$target_port" "$latest_backup" "$target_server:$target_path"
    if [ $? -eq 0 ]; then
        echo "数据传输完成，请检查目标服务器相应路径！"
        echo "$(date +'%Y-%m-%d %H:%M:%S') - 传输完成" >> "$logpath"
    else
        echo "传输失败，请检查输入信息是否正确！"
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
        echo "备份完成"
        echo "$(date +'%Y-%m-%d %H:%M:%S') - 备份完成">> "$logpath"
        ;;
    "t")
        transfer_to_server
        echo "传输完成"
        echo "$(date +'%Y-%m-%d %H:%M:%S') - 传输完成">> "$logpath"
        ;;
    "s")
        perform_backup
        transfer_to_server
        echo "$(date +'%Y-%m-%d %H:%M:%S') - 备份与传输完成">> "$logpath"
        ;;
    *)
        echo "用法: sudo $0 [b|t|s]"
        echo "b是备份,t是迁移,s是备份+迁移"
        echo "迁移需要目标服务器用户名@IP，端口号和密码"
        echo "可以手动修改，将目标服务器信息写入脚本，但是出于安全性考虑：不建议！"
        echo "如sudo $0 b 表示备份文件夹"
        exit 1
        ;;
esac
