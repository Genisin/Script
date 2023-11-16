#!/bin/bash

#######定时清理设置（可选）##########
#crontab -e    #打开系统的定时任务列表
#分（0-59），时（0-23），日（1-31），月（1-12），星期（0-6，其中0表示星期天）
#0 0 * * 0 /bin/bash /path/to/your/script.sh  #设置清理时间
#路径： /var/log
#大小：1MB： 1048576 全清： 0 
log_dir="/"
max_log_size=100   # 100Kb
logpath="/var/log/logclean.log"

# 更新软件包并清理多余软件包
echo "正在更新软件包并清理多余软件包，之后将清理日志....."
if { apt update -y && apt full-upgrade -y && sudo apt dist-upgrade && apt autoremove -y && apt autoclean -y; } > /dev/null 2>&1; then
    echo "$(date +'%Y-%m-%d %H:%M:%S') - 已更新软件包并清理多余软件包" >> "$logpath"
else
    echo "$(date +'%Y-%m-%d %H:%M:%S') - 软件包更新和清理失败" >> "$logpath"
fi

# 使用 find 命令获取所有子文件夹中的 .log 文件并将结果保存到 log_files 数组
log_files=()
while IFS= read -r -d $'\0' file; do
    log_files+=("$file")
done < <(find "$log_dir" -name "*.log" -print0)

# 遍历日志文件列表并进行清理
for log_file in "${log_files[@]}"; do
    # 获取当前日志文件大小
    current_size=$(du -b "$log_file" | awk '{print $1}')

    if [ "$current_size" -gt "$max_log_size" ]; then
        > "$log_file"
        echo "    日志已清理    - $log_file"

    else
        echo "日志未达到清理条件 - $log_file"
        echo "$(date +'%Y-%m-%d %H:%M:%S') -     日志已清理    - $log_file" >> "$logpath"
        echo "$(date +'%Y-%m-%d %H:%M:%S') - 日志未达到清理条件 - $log_file" >> "$logpath"
    fi
done