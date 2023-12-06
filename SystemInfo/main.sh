#!/bin/bash

# 设置ANSI颜色码
GREEN='\033[0;32m'
NC='\033[0m'

# 获取系统版本信息
system_version=$(lsb_release -d | awk -F"\t" '{print $2}')
# 获取系统架构
system_architecture=$(uname -m)
# 获取内核版本
kernel_version=$(uname -r)
#拥塞算法
congestion_algorithm=$(sysctl -n net.ipv4.tcp_congestion_control)
queue_algorithm=$(sysctl -n net.core.default_qdisc)

# 获取CPU核数
cpu_cores=$(nproc)
# 获取CPU型号和主频
cpu_model=$(lscpu | grep "Model name" | awk -F ": " '{sub(/^[ \t]+/, "", $2); print $2}')

# 获取硬盘大小和占用情况
disk_size=$(df -h | awk '/\/$/ {print $2}')
used_disk=$(df -h | awk '/\/$/ {print $3}')
disk_usage=$(df | awk '/\/$/ {printf "% 5.2f", ($3/$2)*100}')
format_disk_usage=$(df | awk '/\/$/ {printf "% 5.2f", $3/1024}') # 格式化硬盘占用为GB

# 获取内存大小和占用（MB）
memory_size=$(free -m | awk '/Mem:/ {print $2}')
used_memory=$(free -m | awk '/Mem:/ {print $3}')
memory_usage=$(free | awk '/Mem:/ {printf "% 5.2f", ($3/$2)*100}')
format_memory_usage=$(free -m | awk '/Mem:/ {printf "% 5.2f", $3})  # 格式化内存占用为MB

# 获取虚拟内存大小和占用情况
swap_size=$(free -h | awk '/Swap/ {print $2}')
used_swap=$(free -h | awk '/Swap/ {print $3}')
swap_usage=$(free | awk '/Swap/ {printf "% 5.2f", ($3/$2)*100}')
format_swap_usage=$(free -h | awk '/Swap/ {printf "% 5.2f", $3/1024}') # 格式化虚拟内存占用为GB

#********IP信息********#
ipv4_address=$(curl -s ipv4.ip.sb)
ipv6_address=$(curl -s ipv6.ip.sb)
ip_info=$(curl -s ipinfo.io)
country=$(echo "$ip_info" | jq -r '.country')
city=$(echo "$ip_info" | jq -r '.city')
isp_info=$(echo "$ip_info" | jq -r '.org')
ip_address=$(curl -s ip.p3terx.com | awk 'NR==1')

clear
# 打印结果
echo -e "${GREEN}======系统信息=======${NC}"
echo "系统架构：$system_architecture"
echo "系统版本：$system_version"
echo "内核版本：$kernel_version"
echo "拥堵算法: $congestion_algorithm $queue_algorithm"
echo -e "${GREEN}=======IP信息========${NC}"
echo "IPv4:     $ipv4_address"
echo "IPv6:     $ipv6_address"
echo "优先IP:   $ip_address"
echo "IP归属地:  $country $city"
echo "IPv4运营商: $isp_info"
echo -e "${GREEN}======硬件信息=======${NC}"
echo "CPU型号： $cpu_model @  $cpu_cores 核"
echo "硬盘占用/硬盘大小：   $format_disk_usage GB / $disk_size     占用率：$disk_usage%"
echo "内存占用/内存大小：$format_memory_usage MB / $memory_size MB    占用率：$memory_usage%"
echo "虚拟内存占用/大小：$used_swap / $format_swap_usage GB    占用率：$swap_usage%"