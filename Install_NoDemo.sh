####依次修改：依赖安装脚本的文件原始内容链接 -> 脚本名 -> 主脚本的文件的原始内容链接 -> 添加依赖
# 替换blob为   -> raw <-
#修改完成后赋值此段代码进行运行
#    sudo wget -O Dyinstall.sh 依赖安装脚本的文件原始内容链接 && chmod +x Dyinstall.sh && sudo ./Dyinstall.sh
 
# 脚本名字
script_name="脚本名.sh"
#脚本下载地址 
main_script_url= "主脚本的文件的原始内容链接"

#创建主脚本下载路径
mkdir -p /root/data/script
download_path="/root/data/script"

#下载主脚本到指定文件夹并赋予执行权限
sudo wget -O "$download_path/$script_name" "$main_script_url" && chmod +x "$download_path/$script_name"

if sudo wget -O "$download_path/$script_name" "$main_script_url" && sudo chmod +x "$download_path/$script_name"; then
    echo "所需依赖已全部安装成功，此脚本即将自动删除"
    echo "请输入-> sudo $download_path/$script_name <-进行运行所需脚本"
    rm "$0" # 删除当前脚本
else
    echo "下载脚本失败，依赖安装成功，请检查下载失败原因!"
    rm "$0" # 删除当前脚本
fi