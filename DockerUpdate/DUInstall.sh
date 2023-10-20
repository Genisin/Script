####依次修改：依赖安装脚本的文件原始内容链接 -> 脚本名 -> 主脚本的文件的原始内容链接
# 替换为   -> raw.githubusercontent.com <- 
#修改完成后赋值此段代码进行运行
#    sudo wget -O Dyinstall.sh https://raw.githubusercontent.com/Genisin/script/main/DockerUpdate/DUInstall.sh && chmod +x Dyinstall.sh && sudo ./Dyinstall.sh
 
# 脚本名字
script_name="DockerUpdate.sh"
#脚本下载地址 
main_script_url="https://raw.githubusercontent.com/Genisin/script/main/DockerUpdate/main.sh"

#字体颜色定义
orange='\033[33m'
green='\033[32m'
plain='\033[0m'

#创建主脚本下载路径
mkdir -p /root/data/script
download_path="/root/data/script"

#下载主脚本到指定文件夹并赋予执行权限
if sudo wget -L -O "$download_path/$script_name" "$main_script_url" && sudo chmod +x "$download_path/$script_name"; then
    echo "请输入-> ${green}sudo $download_path/$script_name${plain} <-进行运行"
    rm "$0" # 删除当前脚本
else
    echo -e "下载脚本失败，请再次尝试！（若多次尝试仍无法下载，建议手动下载）!"
    rm "$0" # 删除当前脚本
fi