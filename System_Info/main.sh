#!/bin/bash

# 获取系统版本信息
system_version=$(lsb_release -d | awk -F"\t" '{print $2}')

# 获取系统架构
system_architecture=$(uname -m)

# 获取内核版本
kernel_version=$(uname -r)

# 获取CPU核数
cpu_cores=$(nproc)

# 获取CPU型号和主频
cpu_model=$(lscpu | grep "Model name" | awk -F ": " '{sub(/^[ \t]+/, "", $2); print $2}')

# 获取内存大小（MB）
memory_size=$(free -m | awk '/Mem:/ {print $2}')

# 获取当前内存占用（MB）
used_memory=$(free -m | awk '/Mem:/ {print $3}')
memory_usage=$(free | awk '/Mem:/ {printf "% 5.2f", ($3/$2)*100}')

# 获取硬盘大小和占用情况
disk_size=$(df -h | awk '/\/$/ {print $2}')
used_disk=$(df -h | awk '/\/$/ {print $3}')
disk_usage=$(df | awk '/\/$/ {printf "% 5.2f", ($3/$2)*100}')

# 格式化内存和硬盘使用量
format_memory_usage=""
format_disk_usage=""
if [ "$used_memory" -lt 1024 ]; then
    format_memory_usage=$(printf "% 5.2f MB" $used_memory)
else
    format_memory_usage=$(printf "% 5.2f GB" $(echo "scale=2; $used_memory / 1024" | bc))
fi

if [ "$used_disk" -lt 1 ]; then
    format_disk_usage=$(printf "% 5.2f MB" $(echo "scale=2; $used_disk * 1024" | bc))

else
    format_disk_usage=$(printf "% 5.2f GB" $used_disk)
fi

# 打印结果
echo "硬盘大小：$disk_size"
echo "内存大小：$memory_size MB"
echo "系统架构：$system_architecture"
echo "系统版本：$system_version"
echo "内核版本：$kernel_version"
echo "硬盘占用：  $format_disk_usage，占用率：$disk_usage%"
echo "内存占用：$format_memory_usage，占用率：$memory_usage%"
echo "CPU型号：$cpu_model @$cpu_cores 核"
