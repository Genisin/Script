# 文件备份脚本
---
## 安装方法
```
sudo wget -L -O Dyinstall.sh https://raw.githubusercontent.com/Genisin/script/main/Document_Backup/DBInstall.sh && chmod +x Dyinstall.sh && sudo ./Dyinstall.sh
```
使用安装脚本进行执行：
* 安装脚本直接下载到当前目录下，但无需担心，运行过后直接自动清除
* 备份脚本会默认下载到/root/data/script路径下
---
## 使用说明

### 运行说明
```
sudo /root/data/script/Document_Backup.sh <choice>
# <chioce>有 b，t，s 三种选择，分别对应不同功能
```
* b是备份,t是迁移,s是备份+迁移  
> sudo /root/data/script/Document_Backup.sh b 表示备份文件夹

* 默认备份的文件夹是 /root/data/docker_data（可修改脚本，按需备份）
* 迁移需要目标服务器：用户名@IP、SSH连接端口号、密码  
> 目标服务器地址(用户名@IP):      root@1.1.1.1  
> 请输入目标服务器SSH端口号： 22  
> SSH连接密码（默认为隐藏）:     your password  

* 如果修改脚本存放位置，运行命令也要修改  
### 添加定时任务自动备份
```
crontab -e    #打开系统的定时任务列表

* * * * * /bin/bash /root/data/script/Document_Backup.sh b  #设置运行时间
```
> 分（0-59），时（0-23），日（1-31），月（1-12），星期（0-6，其中0表示星期天）

### 存储位置说明 
1. 备份位置：/root/data/docker_data_backup_gz
2. 迁移至目标服务器位置：/root/data/docker_data_backup_gz
---
## 删除
只需运行以下命令即可：
```
rm /root/data/script/Document_Backup.sh
```
对已备份文件可查看存储位置按需删除

