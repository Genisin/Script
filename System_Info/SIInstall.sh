#!/bin/bash

#依赖下载安装和主脚本下载！！！ 替换域名为 -> raw.githubusercontent.com <-
#wget -O Dyinstall.sh https://raw.githubusercontent.com/Genisin/script/edit/main/System_Info/SIInstall.sh && chmod +x Dyinstall.sh && sudo ./Dyinstall.sh
 
# 脚本名字
script_name="System_Info.sh"
#脚本下载地址 
main_script_url= "https://raw.githubusercontent.com/Genisin/script/blob/main/System_Info/main.sh"

#创建主脚本下载路径
mkdir -p /root/data/script
download_path="/root/data/script"

#下载主脚本到指定文件夹并赋予执行权限
wget -O "$download_path/$script_name" "$main_script_url" && chmod +x "$download_path/$script_name"

echo "所需依赖已全部安装成功，此脚本即将自动删除"
echo "请输入-> sudo $download_path/$script_name  <-进行运行所需脚本"
#删除此脚本（此脚本是为检测依赖是否安装并下载主脚本）
rm "$0"
