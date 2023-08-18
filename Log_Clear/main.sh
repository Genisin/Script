#!/bin/bash

#######定时清理设置（可选）##########
#crontab -e    #打开系统的定时任务列表
#分（0-59），时（0-23），日（1-31），月（1-12），星期（0-6，其中0表示星期天）
#0 0 * * 0 /bin/bash /path/to/your/script.sh  #设置清理时间

log_dir="/var/log"
max_log_size=1048576  # 1MB 
logpath="/var/log/loglimit.log"

# 获取日志文件列表
log_files=("$log_dir"/*.log)

# 遍历日志文件列表
for log_file in "${log_files[@]}"; do
    # 获取当前日志文件大小
    current_size=$(du -b "$log_file" | awk '{print $1}')

    if [ "$current_size" -gt "$max_log_size" ]; then
        > "$log_file"
        echo "日志已清理 - $log_file"
        echo "$(date +'%Y-%m-%d %H:%M:%S') - 日志已清理" - $log_file >> "$logpath"
    else
        echo "日志未达到清理条件 - $log_file"
        echo "$(date +'%Y-%m-%d %H:%M:%S') - 日志未达到清理条件" - $log_file >> "$logpath"
    fi
done
