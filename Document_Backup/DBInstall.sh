#!/bin/bash

####依次修改：依赖安装脚本的文件原始内容链接 -> 脚本名 -> 主脚本的文件的原始内容链接 -> 添加依赖
# 替换blob为   -> raw <-
#修改完成后赋值此段代码进行运行
#    sudo wget -O Dyinstall.sh https://github.com/Genisin/script/raw/main/Document_Backup/DBInstall.sh && chmod +x Dyinstall.sh && sudo ./Dyinstall.sh
#    sudo wget -O Dyinstall.sh https://github.com/Genisin/script/raw/main/Document_Backup/main.sh && chmod +x Dyinstall.sh && sudo ./Dyinstall.sh
# 脚本名字
script_name="Document_Backup.sh"
#脚本下载地址 
main_script_url="https://github.com/Genisin/script/raw/main/Document_Backup/main.sh"

# 定义要安装的依赖名称
dependencies=("rsync" "sshpass")

#创建主脚本下载路径
mkdir -p /root/data/script
download_path="/root/data/script"

echo "安装依赖中..."
# 检查系统发行版，并根据不同发行版使用不同的包管理工具安装依赖
if command -v apt-get >/dev/null 2>&1; then
    # Debian/Ubuntu
    apt-get update
    apt-get install -y "${dependencies[@]}"
elif command -v yum >/dev/null 2>&1; then
    # CentOS/RHEL
    yum update
    yum install -y "${dependencies[@]}"
elif command -v pacman >/dev/null 2>&1; then
    # Arch Linux
    pacman -Syu --noconfirm
    pacman -S --noconfirm "${dependencies[@]}"
else
    echo "抱歉，该系统无法安装相应依赖"
    exit 1
fi

echo "依赖安装完成，开始下载脚本..."
#下载主脚本到指定文件夹并赋予执行权限
if sudo wget -O  "$download_path/$script_name"  "$main_script_url"  &&  sudo chmod +x  "$download_path/$script_name" ; then
    echo "所需依赖已全部安装成功，此脚本即将自动删除"
    echo "请输入-> sudo $download_path/$script_name [b|t|s] <-进行运行所需脚本"
    rm "$0" # 删除当前脚本
else
    echo "下载脚本失败，依赖安装成功，请检查下载失败原因!"
    rm "$0" # 删除当前脚本
fi