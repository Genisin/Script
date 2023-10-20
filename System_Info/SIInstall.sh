#!/bin/bash

####依次修改：依赖安装脚本的文件原始内容链接 -> 脚本名 -> 主脚本的文件的原始内容链接
# 替换blob为   -> raw <-
#修改完成后赋值此段代码进行运行
#    sudo wget -L -O Dyinstall.sh https://raw.githubusercontent.com/Genisin/script/main/System_Info/SIInstall.sh && chmod +x Dyinstall.sh && sudo ./Dyinstall.sh
 
# 脚本名字
script_name="System_Info.sh"
#脚本下载地址 
main_script_url="https://raw.githubusercontent.com/Genisin/script/main/System_Info/main.sh"

#创建主脚本下载路径
mkdir -p /root/data/script
download_path="/root/data/script"

# 定义要安装的依赖名称
dependencies=( "bc" )

# 创建主脚本下载路径
mkdir -p /root/data/script
download_path="/root/data/script"

echo "检查依赖..."
# 检查依赖是否已经安装
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
    echo "所有依赖已经安装，无需操作。"
else
    echo "安装依赖中..."
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            if command -v apt-get >/dev/null 2>&1; then
                # Debian/Ubuntu
                apt-get install -y "$dep"
            elif command -v yum >/dev/null 2>&1; then
                # CentOS/RHEL
                yum install -y "$dep"
            elif command -v pacman >/dev/null 2>&1; then
                # Arch Linux
                pacman -S --noconfirm "$dep"
            else
                echo "抱歉，无法为该系统无法安装依赖"
                echo "为不占用您的系统空间，将自动删除脚本！"
                rm "$0" # 删除当前脚本
                exit 1
            fi
        fi
    done
fi

echo "依赖安装完成，开始下载脚本..."
# 下载主脚本到指定文件夹并赋予执行权限
if sudo wget -L -O "$download_path/$script_name" "$main_script_url" && sudo chmod +x "$download_path/$script_name"; then
    echo "发现已有依赖：${existing_deps[*]}"
    echo "现已具备依赖：${dependencies[*]}"
    echo "已具备运行脚本的所有依赖，此脚本任务结束，即将自动删除"
    echo "请输入-> sudo $download_path/$script_name <-进行运行"
    rm "$0" # 删除当前脚本
else
    echo "发现已有依赖：${existing_deps[*]}"
    echo "现已具备依赖：${dependencies[*]}"
    echo "下载脚本失败，请再次尝试！（若多次尝试仍无法下载，建议手动下载）!"
    rm "$0" # 删除当前脚本
fi
