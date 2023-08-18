#!/bin/bash

#依赖下载安装和主脚本下载
#  wget -O Dyinstall.sh https://github.com/Genisin/script/raw/main/Log_Clean/LCInstall_T.sh && chmod +x Dyinstall.sh && sudo ./Dyinstall.sh
 
# 定义脚本名变量
script_name="logclean.sh"

#创建主脚本下载路径
mkdir -p /root/data/script
download_path="/root/data/script"

#下载主脚本到指定文件夹并赋予执行权限
#替换域名raw.githubusercontent.com
wget -O "$download_path/$script_name" https://github.com/Genisin/script/raw/main/Log_Clean/main.sh && chmod +x "$download_path/$script_name"

echo "所需依赖已全部安装成功，请输入-> sudo $download_path/$script_name <-运行"

#删除此脚本（此脚本是为检测依赖是否安装并下载主脚本）
rm "$0"