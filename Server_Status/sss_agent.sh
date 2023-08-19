#!/bin/bash

#========================================================
#   System Required: CentOS 7+ / Debian 8+ / Ubuntu 16+ /
#     Arch 未测试
#   Description: Server Status 监控安装脚本
#   Github: https://github.com/lidalao/ServerStatus
#========================================================

#修改大佬的脚本，让自己用的舒服一点
#自定义安装路径 /root/data/docker_data/sss/sss_agent
#原路径 /opt/sss
SSS_BASE_PATH="/root/data/docker_data/sss/sss_agent"
SSS_AGENT_PATH="${SSS_BASE_PATH}/agent"
SSS_AGENT_SERVICE="/etc/systemd/system/sss-agent.service"
GITHUB_RAW_URL="https://raw.githubusercontent.com/lidalao/ServerStatus/master"

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
export PATH=$PATH:/usr/local/bin

pre_check() {
    command -v systemctl >/dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo "不支持此系统：未找到 systemctl 命令"
        exit 1
    fi

    # check root
    [[ $EUID -ne 0 ]] && echo -e "${red}错误: ${plain} 必须使用root用户运行此脚本！\n" && exit 1
}

install_soft() {
    (command -v yum >/dev/null 2>&1 && yum install $* -y) ||
        (command -v apt >/dev/null 2>&1 && apt update && apt install $* -y) ||
        (command -v pacman >/dev/null 2>&1 && pacman -Syu $*) ||
        (command -v apt-get >/dev/null 2>&1 && apt update && apt-get install $* -y)
}

install_base() {
    (command -v git >/dev/null 2>&1 && command -v curl >/dev/null 2>&1 && command -v wget >/dev/null 2>&1 && command -v tar >/dev/null 2>&1) ||
        (install_soft curl wget python3)
}

modify_agent_config() {
    echo -e "> 修改Agent配置"

    wget -O $SSS_AGENT_SERVICE ${GITHUB_RAW_URL}/sss-agent.service >/dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo -e "${red}文件下载失败，请检查本机能否连接 ${GITHUB_RAW_URL}${plain}"
        return 0
    fi

    if [ $# -lt 3 ]; then
        echo "server status agent需要3个参数，请重新输入" 
        return 0
    else
        sss_host=$1
        sss_user=$2
        sss_pass=$3
    fi

    sed -i "s/sss_host/${sss_host}/" ${SSS_AGENT_SERVICE}
    sed -i "s/sss_user/${sss_user}/" ${SSS_AGENT_SERVICE}
    sed -i "s/sss_pass/${sss_pass}/" ${SSS_AGENT_SERVICE}

    echo -e "Agent配置 ${green}修改成功，请稍等重启生效${plain}"

    systemctl daemon-reload
    systemctl enable sss-agent
    systemctl restart sss-agent
}

install_agent() {
    install_base

    echo -e "> 安装监控Agent"

    # 哪吒监控文件夹
    mkdir -p $SSS_AGENT_PATH
    chmod 777 -R $SSS_AGENT_PATH

    echo -e "正在下载监控端"
    wget --no-check-certificate -qO client-linux.py $GITHUB_RAW_URL/client-linux.py
    mv client-linux.py $SSS_AGENT_PATH

    modify_agent_config "$@"
}

uninstall_agent() {
    (systemctl stop sss-agent) >/dev/null 2>&1
    (systemctl disable sss-agent) >/dev/null 2>&1
    # 检查 $SSS_AGENT_PATH 是否存在
    if [ -d "$SSS_AGENT_PATH" ]; then
	    echo "文件 $SSS_AGENT_PATH 存在，正在进行删除..."
	    rm -rf "$SSS_AGENT_PATH" >/dev/null 2>&1
    fi
	# 检查 $SSS_AGENT_SERVICE 是否存在
	if [ -f "$SSS_AGENT_SERVICE" ]; then
	    echo "服务 $SSS_AGENT_SERVICE 存在，正在删除..."
	    rm -rf "$SSS_AGENT_SERVICE" >/dev/null 2>&1
	fi
    systemctl daemon-reload
}

show_menu() {
    echo -e "
    ${green}Server Status监控管理脚本${plain}
    --- https://github.com/lidalao/sss ---
    ${green}1.${plain}  安装监控Agent
    ${green}2.${plain}  卸载Agent
    ${green}0.${plain}  退出脚本
    "
    echo && read -ep "请输入选择 [0-2]: " num

    case "${num}" in
    0)
        exit 0
        ;;
 
    1)
        install_agent
        ;;
    2)
        uninstall_agent
        echo -e "${green}卸载Agent完成${plain}"

	        echo && read -ep "是否卸载此脚本？[y/N]: " choose
	        case "${choose}" in
	    [Yy])
	        echo "ServiceStatus服务端脚本已删除"
	        rm "$0"
	        ;;
	 
	    *)
	        echo "ServiceStatus服务端脚本已保留"
	        exit 0
	        ;;
	    esac
        
        ;;
    *)
        echo -e "${red}请输入正确的数字 [0-2]${plain}"
        ;;
    esac
}

pre_check

if [[ $# == 3 ]]; then
    uninstall_agent
    install_agent "$@"
else
    show_menu
fi



