#!/bin/bash

#依赖下载安装和主脚本下载
#curl -o Dyinstall.sh https://github.com/Genisin/script/raw/main/Log_Clear/LCInstall_T.sh && chmod +x Dyinstall.sh && sudo ./Dyinstall.sh
 
# 定义脚本名变量
script_name="logclear.sh"

#创建主脚本下载路径
mkdir -p /root/data/script
download_path="/root/data/script"

#下载主脚本到指定文件夹
curl -o "$download_path/$script_name" https://github.com/Genisin/script/raw/main/Log_Clear/main.sh;

# 赋予执行权限
chmod +x "$download_path/$script_name"
echo "所需依赖已全部安装成功，请输入sudo $download_path/$script_name运行"

#删除此脚本（此脚本是为检测依赖是否安装并下载主脚本）
rm "$0"
