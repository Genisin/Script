#!/bin/bash

# 设置文件下载地址
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"

# 设置目标目录
TARGET_DIR="/root/data/docker_data/xui/xray/"

# 下载并替换 geoip.dat
wget -O "${TARGET_DIR}geoip.dat" "${GEOIP_URL}"

# 下载并替换 geosite.dat
wget -O "${TARGET_DIR}geosite.dat" "${GEOSITE_URL}"
