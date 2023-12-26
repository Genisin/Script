#!/bin/bash

#######定时清理设置（可选）##########
#crontab -e    #打开系统的定时任务列表
#分（0-59），时（0-23），日（1-31），月（1-12），星期（0-6，其中0表示星期天）
#0 0 * * 0 /bin/bash /path/to/your/script.sh  #设置清理时间
#路径： /var/log
#大小：1MB： 1048576 全清： 0 
log_dir="/"
max_log_size=0   # 100Kb

#字体颜色定义
orange='\033[33m'
green='\033[32m'
plain='\033[0m'
echo "正在查找所有日志文件，请稍后..."
# 使用 find 命令获取所有子文件夹中的 .log 文件并将结果保存到 log_files 数组
#log_files=()
#while IFS= read -r -d $'\0' file; do
#    log_files+=("$file")
#done < <(find "$log_dir" -type f -name "*.log" -print0) > /dev/null 2>&1

log_files_gz=()
while IFS= read -r -d $'\0' file; do
    log_files_gz+=("$file")
done < <(find "$log_dir" -type f -name "*.log.*.gz" -print0) > /dev/null 2>&1

log_n_files=()
while IFS= read -r -d $'\0' file; do
    log_n_files+=("$file")
done < <(find "$log_dir" -type f -name "*.log.*" -print0) > /dev/null 2>&1


echo "日志文件查找完成，开始清理..."
# 遍历日志文件列表并进行清理
#for log_file in "${log_files[@]}"; do
#    # 获取当前日志文件大小
#    current_size=$(du -b "$log_file" | awk '{print $1}')
#
#    if [ "$current_size" -gt "$max_log_size" ]; then
#        truncate -s 0 "$log_file"  # 使用truncate清空文件而不删除
#        echo -e "${green}-已重置=> $log_file${plain}"
#    else
#        echo "-未清理 $log_file"
#    fi
#done

for log_file in "${log_files_gz[@]}"; do
   rm "${log_file}" > /dev/null 2>&1 && echo -e "${orange}-已删除=> ${log_file}${plain}"

done

for log_file in "${log_n_files[@]}"; do
   rm "${log_file}" > /dev/null 2>&1 && echo -e "${orange}-已删除=> ${log_file}${plain}"
done

rm /var/log/btmp.* /var/log/syslog.*  /var/log/dmesg.* /var/log/*.gz > /dev/null 2>&1

journalctl --vacuum-size=50M > /dev/null 2>&1
echo -e "${orange}-已删除 => 大于 50M journals文件${plain}"