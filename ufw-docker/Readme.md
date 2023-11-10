参考[ufw-docker](https://github.com/chaifeng/ufw-docker#%E5%A4%AA%E9%95%BF%E4%B8%8D%E6%83%B3%E8%AF%BB)



* 禁用 docker 的 iptables 功能，并允许docker访问网络
* 
1. 备份after.rules
```
sudo cp /etc/ufw/after.rules /etc/ufw/after.rules.backup
```
> 还原after.rules 
```
sudo cp /etc/ufw/after.rules.backup /etc/ufw/after.rules
```
2. 修改 UFW 的配置文件 /etc/ufw/after.rules，在最后添加上如下规则:
**ufw-user-forward适用于新版Ubuntu，旧版必须用ufw-user-input**
```
# BEGIN UFW AND DOCKER
*filter
:ufw-user-input - [0:0]
:ufw-docker-logging-deny - [0:0]
:DOCKER-USER - [0:0]
-A DOCKER-USER -j ufw-user-input

-A DOCKER-USER -j RETURN -s 10.0.0.0/8
-A DOCKER-USER -j RETURN -s 172.16.0.0/12
-A DOCKER-USER -j RETURN -s 192.168.0.0/16

-A DOCKER-USER -p udp -m udp --sport 53 --dport 1024:65535 -j RETURN

-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 192.168.0.0/16
-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 10.0.0.0/8
-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 172.16.0.0/12
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 192.168.0.0/16
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 10.0.0.0/8
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 172.16.0.0/12

-A DOCKER-USER -j RETURN

-A ufw-docker-logging-deny -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "[UFW DOCKER BLOCK] "
-A ufw-docker-logging-deny -j DROP

COMMIT
# END UFW AND DOCKER
```
3. 重启UFW
```
sudo systemctl restart ufw
```
**重启 UFW 之后规则也无法生效，重启服务器**

4. 部署服务若无法打开，则开启docker0容器互访
```
sudo iptables -A INPUT -i docker0 -j ACCEPT;
sudo iptables -A FORWARD -i docker0 -j ACCEPT
# 重启生效
sudo mkdir -p /etc/iptables/
sudo iptables-save > /etc/iptables/rules.v4
```