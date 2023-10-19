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

if [ $(echo "$used_memory < 1024" | bc) -eq 1 ]; then
    format_memory_usage=$(printf "% 5.2f MB" $used_memory)
else
    format_memory_usage=$(printf "% 5.2f GB" $(echo "scale=2; $used_memory / 1024" | bc))
fi

used_disk_f=${used_disk//[^0-9.]/}  # 移除非数字字符

# 将字符串数字转换为浮点数
used_disk_float=$(echo "$used_disk_f" | bc)

# 使用 bc 进行浮点数比较
if [ $(echo "$used_disk_float < 1" | bc) -eq 1 ]; then
    format_disk_usage=$(printf "% 5.2f MB" $(echo "scale=2; $used_disk_float * 1024" | bc))
else
    format_disk_usage=$(printf "% 5.2f GB" $used_disk_float)
fi


# 打印结果  
echo "系统架构：$system_architecture"
echo "系统版本：$system_version"
echo "内核版本：$kernel_version"
echo "CPU型号： $cpu_model @  $cpu_cores 核"

# 使用curl和ipinfo.io查询IP信息
ip_info=$(curl -s ipinfo.io)


if [[ -n "$ipv4_address" && "$ipv4_address" != "127.0.0.1" ]]; then
    # 从查询结果中提取IP地址和IP类型
    ipv4_address=$(echo "$ip_info" | jq -r '.ip')
    ip_country=$(echo "$ip_info" | jq -r '.country')
    ip_city=$(echo "$ip_info" | jq -r '.city')
    echo "IPv4:     $ipv4_address from $ip_country / $ip_city"
else
    echo "IPv4:     不支持"
fi

ipv6_address=$(curl -s 6.ipw.cn)
if [ -n "$ipv6_address" ]; then
  echo "IPv6:     $ipv6_address"
else
  echo "IPv6:     不支持"
fi

ip_address=$(curl -s test.ipw.cn)
echo   "优先级IP: $ip_address"

echo "硬盘占用/硬盘大小：   $format_disk_usage/$disk_size     占用率：$disk_usage%"
echo "内存占用/内存大小：$format_memory_usage/$memory_size MB    占用率：$memory_usage%"