#!/bin/bash

#######定时清理设置（可选）##########
#crontab -e    #打开系统的定时任务列表
#分（0-59），时（0-23），日（1-31），月（1-12），星期（0-6，其中0表示星期天）
#0 0 * * 0 /bin/bash /path/to/your/script.sh  #设置清理时间
#路径： /var/log
#大小：1MB： 1048576 全清： 0 
log_dir="/"
max_log_size=0   # 100Kb

echo "正在查找所有日志文件，请稍后..."
# 使用 find 命令获取所有子文件夹中的 .log 文件并将结果保存到 log_files 数组
log_files=()
while IFS= read -r -d $'\0' file; do
    log_files+=("$file")
done < <(find "$log_dir" -name "*.log" -print0)

log_files_gz=()
while IFS= read -r -d $'\0' file; do
    log_files_gz+=("$file")
done < <(find "$log_dir" -name "*.log.*.gz" -print0)

log_n_files=()
while IFS= read -r -d $'\0' file; do
    log_n_files+=("$file")
done < <(find "$log_dir" -name "*.log.*" -print0)

echo "日志文件查找完成，开始清理..."
# 遍历日志文件列表并进行清理
for log_file in "${log_files[@]}"; do
    # 获取当前日志文件大小
    current_size=$(du -b "$log_file" | awk '{print $1}')

    if [ "$current_size" -gt "$max_log_size" ]; then
        > "$log_file"
        echo "    日志已清理    - $log_file"
    else
        echo "日志未达到清理条件 - $log_file"
    fi
done

for log_file in "${log_files_gz[@]}"; do
   rm "${log_file}" 1> /dev/null 2>&1 && echo "$(date +'%Y-%m-%d %H:%M:%S') - 已删除 ${log_file}"

done

for log_file in "${log_n_files[@]}"; do
   rm "${log_file}" 1> /dev/null 2>&1 && echo "$(date +'%Y-%m-%d %H:%M:%S') - 已删除 ${log_file}"
done

rm /var/log/btmp.* /var/log/syslog.* /var/log/*.gz 1> /dev/null 2>&1