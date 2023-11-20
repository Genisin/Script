#!/bin/bash

# 脚本名字
script_name="GeoUpdate.sh"
# 此链接为主脚本下载地址 
main_script_url="https://raw.githubusercontent.com/Genisin/Script/main/GeoUpdate/main.sh"

#创建主脚本下载路径
mkdir -p /root/data/script
download_path="/root/data/script"

#字体颜色定义
orange='\033[33m'
green='\033[32m'
plain='\033[0m'

#下载主脚本到指定文件夹并赋予执行权限
if sudo wget -L -O "$download_path/$script_name" "$main_script_url" && sudo chmod +x "$download_path/$script_name"; then
    echo -e "请输入-> ${green}sudo $download_path/$script_name${plain} <-进行运行"
    rm "$0" # 删除当前脚本
else
    echo -e "${orange}下载脚本失败，请再次尝试！${plain}"
    rm "$0" # 删除当前脚本
fi
