#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' # 恢复默认颜色

  ipv4_address=$(curl -s ipv4.ip.sb)
  ipv6_address=$(curl -s --max-time 2 ipv6.ip.sb)


if [ "$(uname -m)" == "x86_64" ]; then
  cpu_info=$(cat /proc/cpuinfo | grep 'model name' | uniq | sed -e 's/model name[[:space:]]*: //')
else
  cpu_info=$(lscpu | grep 'Model name' | sed -e 's/Model name[[:space:]]*: //')
fi

cpu_usage=$(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')
cpu_usage_percent=$(printf "%.2f" "$cpu_usage")%

cpu_cores=$(nproc)

mem_info=$(free -b | awk 'NR==2{printf "%.2f/%.2f MB (%.2f%%)", $3/1024/1024, $2/1024/1024, $3*100/$2}')

disk_info=$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)", $3,$2,$5}')

country=$(curl -s ipinfo.io/country)
city=$(curl -s ipinfo.io/city)

isp_info=$(curl -s ipinfo.io/org)

cpu_arch=$(uname -m)

hostname=$(hostname)

kernel_version=$(uname -r)

congestion_algorithm=$(sysctl -n net.ipv4.tcp_congestion_control)
queue_algorithm=$(sysctl -n net.core.default_qdisc)

    # 尝试使用 lsb_release 获取系统信息
    os_info=$(lsb_release -ds 2>/dev/null)

    # 如果 lsb_release 命令失败，则尝试其他方法
    if [ -z "$os_info" ]; then
      # 检查常见的发行文件
      if [ -f "/etc/os-release" ]; then
        os_info=$(source /etc/os-release && echo "$PRETTY_NAME")
      elif [ -f "/etc/debian_version" ]; then
        os_info="Debian $(cat /etc/debian_version)"
      elif [ -f "/etc/redhat-release" ]; then
        os_info=$(cat /etc/redhat-release)
      else
        os_info="Unknown"
      fi
    fi

    current_time=$(date "+%Y-%m-%d %I:%M %p")

    swap_used=$(free -m | awk 'NR==3{print $3}')
    swap_total=$(free -m | awk 'NR==3{print $2}')

    if [ "$swap_total" -eq 0 ]; then
        swap_percentage=0
    else
        swap_percentage=$((swap_used * 100 / swap_total))
    fi

    swap_info="${swap_used}MB/${swap_total}MB (${swap_percentage}%)"

    runtime=$(cat /proc/uptime | awk -F. '{run_days=int($1 / 86400);run_hours=int(($1 % 86400) / 3600);run_minutes=int(($1 % 3600) / 60); if (run_days > 0) printf("%d天 ", run_days); if (run_hours > 0) printf("%d时 ", run_hours); printf("%d分\n", run_minutes)}')
    clear
    echo -e "${GREEN}------系统信息查询-------${NC}"
    echo "主机名: $hostname"
    echo "运营商: $isp_info"
    echo "系统版本: $os_info"
    echo "系统时间: $current_time"
    echo "Linux版本: $kernel_version"
    echo -e "${GREEN}------------------------${NC}"
    echo "地理位置:  $country  $city"
    echo "IPv4: $ipv4_address"
    echo "IPv6: $ipv6_address"
    echo -e "${GREEN}------------------------${NC}"
    echo "CPU架构: $cpu_arch"
    echo "CPU核心数: $cpu_cores"
    echo "CPU占用: $cpu_usage_percent"
    echo "CPU型号: $cpu_info"
    echo -e "${GREEN}------------------------${NC}"
    echo "硬盘占用: $disk_info"
    echo "虚拟内存: $swap_info"
    echo "物理内存: $mem_info"
    echo -e "${GREEN}------------------------${NC}"
    echo "拥堵算法: $congestion_algorithm $queue_algorithm"
    echo -e "${GREEN}------------------------${NC}"
    echo "运行时长: $runtime"
    echo
