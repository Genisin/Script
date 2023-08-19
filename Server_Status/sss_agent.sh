#部分修改版，删除更彻底

#此部分没有必要，原版就已删除干净
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

#卸载过程优化
#    2)
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
 #   *)