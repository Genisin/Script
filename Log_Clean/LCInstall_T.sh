####依次修改：依赖安装脚本的文件原始内容链接 -> 脚本名 -> 主脚本的文件的原始内容链接
# 替换blob为   -> raw <-
#修改完成后赋值此段代码进行运行
#    sudo wget -O Dyinstall.sh https://github.com/Genisin/script/raw/main/Log_Clean/LCInstall_T.sh && chmod +x Dyinstall.sh && sudo ./Dyinstall.sh
 
# 脚本名字
script_name="logclean.sh"
#脚本下载地址 
main_script_url= "https://github.com/Genisin/script/raw/main/Log_Clean/main.sh"

#创建主脚本下载路径
mkdir -p /root/data/script
download_path="/root/data/script"

#下载主脚本到指定文件夹并赋予执行权限
if sudo wget -O "$download_path/$script_name"  "$main_script_url"  &&  sudo chmod +x "$download_path/$script_name" ; then
    echo "请输入-> sudo $download_path/$script_name <-进行运行所需脚本"
    rm "$0" # 删除当前脚本
else
    echo "下载脚本失败，请再次尝试！（若多次尝试仍无法下载，建议手动下载）!"
    rm "$0" # 删除当前脚本
fi