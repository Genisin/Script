#!/bin/bash

# 定义要忽略的文件夹名称的数组
ignore_folders=("Adguard" "sshwifty" "pandora" "xray" "Microbin")
updated_container_count=0

# 遍历指定目录下的子目录
for dir in /root/data/docker_data/*/; do
    if [ -d "$dir" ]; then
        # 获取目录名
        dirname=$(basename "$dir")

        # 检查是否是要忽略的目录
        if [[ " ${ignore_folders[*]} " =~ " $dirname " ]]; then
            echo "忽略目录: $dir"
            continue  # 跳过这个目录，继续下一个
        fi

        echo "进入目录: $dir"
        # 进入子目录
        cd "$dir" || exit 1
        # 检查 Docker Compose 文件是否存在
        if [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ]; then
            # 拉取新镜像并启动容器
            docker-compose pull && docker-compose up -d
            updated_container_count=$((updated_container_count + 1))
        fi
        # 返回到父目录
        cd - || exit 1
    fi
done

#清除未使用镜像
docker image prune -af
echo "已检查更新$updated_container_count 个容器"
