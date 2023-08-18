#!/bin/bash

####依次修改：依赖安装脚本的文件原始内容链接 -> 脚本名 -> 主脚本的文件的原始内容链接 -> 添加依赖
# 替换blob为   -> raw <-
#修改完成后赋值此段代码进行运行
#    sudo wget -O Dyinstall.sh https://github.com/Genisin/script/raw/main/Document_Backup/DBInstall.sh && chmod +x Dyinstall.sh && sudo ./Dyinstall.sh
 
# 脚本名字
script_name="Document_Backup.sh"
# 脚本下载地址 
main_script_url="https://github.com/Genisin/script/raw/main/Document_Backup/main.sh"

# 定义要安装的依赖名称
dependencies=("rsync" "sshpass")

# 检查依赖是否已经安装
echo "检查依赖..."
check_dependencies() {
    local missing_deps=()
    existing_deps=()
    for dep in "${dependencies[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            existing_deps+=("$dep")
        else
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -eq 0 ]; then
        return 0  # 返回0表示所有依赖已经安装
    else
        echo "以下依赖未安装："
        for missing_dep in "${missing_deps[@]}"; do
            echo "$missing_dep"
        done
        return 1  # 返回1表示存在未安装的依赖
    fi
}

if check_dependencies; then
    echo "已有依赖：${existing_deps[*]}"
    echo "所有依赖已经安装，无需操作。"
else
    echo "安装依赖中..."
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            if command -v apt-get >/dev/null 2>&1; then
                # Debian/Ubuntu
                apt-get update
                apt-get install -y "$dep"
            elif command -v yum >/dev/null 2>&1; then
                # CentOS/RHEL
                yum update
                yum install -y "$dep"
            elif command -v pacman >/dev/null 2>&1; then
                # Arch Linux
                pacman -Syu --noconfirm
                pacman -S --noconfirm "$dep"
            else
                echo "抱歉，该系统无法安装依赖 $dep"
                exit 1
            fi
        fi
    done
fi

# 创建主脚本下载路径
mkdir -p /root/data/script
download_path="/root/data/script"

echo "依赖安装完成，开始下载脚本..."
# 下载主脚本到指定文件夹并赋予执行权限
if sudo wget -O "$download_path/$script_name" "$main_script_url" && sudo chmod +x "$download_path/$script_name"; then
    echo "已有依赖：${existing_deps[*]}"
    echo "成功安装依赖：${dependencies[*]}"
    echo "所需依赖已全部安装成功，此脚本即将自动删除"
    echo "请输入-> sudo $download_path/$script_name <-进行运行所需脚本"
    rm "$0" # 删除当前脚本
else
    echo "已有依赖：${existing_deps[*]}"
    echo "成功安装依赖：${dependencies[*]}"
    echo "下载脚本失败，依赖安装成功，请检查下载失败原因!"
    rm "$0" # 删除当前脚本
fi