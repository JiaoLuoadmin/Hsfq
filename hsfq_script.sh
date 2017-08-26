#!/bin/sh
# Compile:by-lanse	2017-08-26
route_vlan=`/sbin/ifconfig br0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " " `
username=`nvram get http_username`
echo
if [ -f "/etc/storage" ]; then
	echo
	echo -e -n "\033[41;37m 开始构建翻墙平台......\033[0m"
	echo
	sleep 3
	if [ ! -d "/etc/storage/dnsmasq.d" ]; then
		echo -e "\e[1;36m 创建 dnsmasq 规则脚本文件夹 \e[0m"
		mkdir -p -m 755 /etc/storage/dnsmasq.d
		cp -f /tmp/hsfq_script.sh /etc/storage/dnsmasq.d/hsfq_script.sh
	fi

	if [ ! -f "/etc/storage/dnsmasq.d/userlist" ]; then
		echo -e "\e[1;36m 创建自定义翻墙规则 \e[0m"
		cat > "/etc/storage/dnsmasq.d/userlist" <<EOF
# 国内dns优化
address=/.taobao./223.6.6.6
address=/.alicdn./223.6.6.6
EOF
	else
		wget --no-check-certificate -t 20 -T 50 https://raw.githubusercontent.com/896660689/Hsfq/master/Userlist -qO /tmp/tmp_userlist
		mv -f /tmp/tmp_userlist /etc/storage/dnsmasq.d/userlist && sleep 3
	fi
	chmod 644 /etc/storage/dnsmasq.d/userlist

	if [ -d "/etc/storage/dnsmasq.d" ]; then
		echo -e "\e[1;33m 创建更新脚本 \e[0m"
		wget --no-check-certificate -t 30 -T 60 https://raw.githubusercontent.com/896660689/Hsfq/master/tmp_up -qO /tmp/tmp_hsfq_update.sh
		mv -f /tmp/tmp_hsfq_update.sh /etc/storage/dnsmasq.d/hsfq_update.sh && sleep 3
		chmod 755 /etc/storage/dnsmasq.d/hsfq_update.sh
	fi

	echo -e "\e[1;36m 创建 DNS 配置文件 \e[0m"
	if [ ! -f "/etc/storage/dnsmasq.d/resolv.conf" ]; then
		cat > /etc/storage/dnsmasq.d/resolv.conf <<EOF
## DNS解析服务器设置
nameserver 127.0.0.1
## 根据网络环境选择DNS.最多6个地址按速排序
nameserver 223.6.6.6
nameserver 8.8.4.4
nameserver 114.114.114.119
nameserver 176.103.130.131
nameserver 119.29.29.29
nameserver 4.2.2.2
EOF
	else
		wget --no-check-certificate -t 20 -T 50 https://raw.githubusercontent.com/896660689/Hsfq/master/resolv.conf -qO /tmp/tmp_resolv.conf
		mv -f /tmp/tmp_resolv.conf /etc/storage/dnsmasq.d/resolv.conf && sleep 3
	fi
	chmod 644 /etc/storage/dnsmasq.d/resolv.conf && chmod 644 /etc/resolv.conf
	cp -f /etc/storage/dnsmasq.d/resolv.conf /tmp/resolv.conf
	sed -i "/#/d" /tmp/resolv.conf;mv -f /tmp/resolv.conf /etc/resolv.conf

	if [ ! -d "/etc/storage/dnsmasq.d/conf" ]; then
		echo -e "\e[1;36m 创建 'FQ' 文件 \e[0m"
		mkdir -p /etc/storage/dnsmasq.d/conf
		echo "address=/localhost/127.0.0.1" > /etc/storage/dnsmasq.d/conf/hosts_fq.conf
	fi

	if [ ! -d "/etc/storage/dnsmasq.d/hosts" ]; then
		echo -e "\e[1;36m 创建 'HOSTS' 文件 \e[0m"
		mkdir -p /etc/storage/dnsmasq.d/hosts
		echo "127.0.0.1 localhost" > /etc/storage/dnsmasq.d/hosts/hosts_ad.conf
	fi

	echo -e "\e[1;36m 创建自定义广告黑名单 \e[0m"
	if [ ! -f "/etc/storage/dnsmasq.d/blacklist" ]; then
		cat > "/etc/storage/dnsmasq.d/blacklist" <<EOF
# 请在下面添加广告黑名单
# 每行输入要屏蔽广告网址不含http://符号
active.admore.com.cn
g.163.com
mtty-cdn.mtty.com
static-alias-1.360buyimg.com
image.yzmg.com
files.jb51.net/image
common.jb51.net/images
du.ebioweb.com/ebiotrade/web_images
www.37cs.com
fuimg.com
sinaimg.cn
ciimg.com
pic.iidvd.com
cnzz.com
statis.api.3g.youku.com
ad.m.qunar.com
lives.l.aiseet.atianqi.com
EOF
	else
		wget --no-check-certificate -t 20 -T 50 https://raw.githubusercontent.com/896660689/Hsfq/master/Blacklist -qO /tmp/tmp_blacklist
		mv -f /tmp/tmp_blacklist /etc/storage/dnsmasq.d/blacklist && sleep 3
	fi
	chmod 644 /etc/storage/dnsmasq.d/blacklist

	echo -e "\e[1;36m 创建自定义广告白名单 \e[0m"
	if [ ! -f "/etc/storage/dnsmasq.d/whitelist" ]; then
		cat > "/etc/storage/dnsmasq.d/whitelist" <<EOF
# 请将误杀的网址添加到在下面白名单
# 每行输入相应准确的网址或关键词即可:
m.baidu.com
my.k2
tv.sohu.com
toutiao.com
jd.com
tejia.taobao.com
temai.taobao.com
ai.m.taobao.com
ai.taobao.com
re.taobao.com
shi.taobao.com
s.click.taobao.com
s.click.tmall.com
ju.taobao.com
dl.360safe.com
down.360safe.com
fd.shouji.360.cn
zhushou.360.cn
shouji.360.cn
hot.m.shouji.360tpcdn.com
EOF
	else
		wget --no-check-certificate -t 20 -T 50 https://raw.githubusercontent.com/896660689/Hsfq/master/Whitelist -qO /tmp/tmp_whitelist
		mv -f /tmp/tmp_whitelist /etc/storage/dnsmasq.d/whitelist && sleep 3
	fi
	chmod 644 /etc/storage/dnsmasq.d/whitelist

	if [ -f "/etc/storage/cron/crontabs/$username" ]; then
		echo -e "\e[1;31m 添加定时计划更新任务 \e[0m"
		sed -i '/hsfq_update.sh/d' /etc/storage/cron/crontabs/$username
		sed -i '$a 45 05 * * 2,4,6 /bin/sh /etc/storage/dnsmasq.d/hsad_update.sh' /etc/storage/cron/crontabs/$username
		killall crond;/usr/sbin/crond
	fi

	if [ -f "/etc/storage/dnsmasq.d/hsfq_update.sh" ]; then
		echo -e -n "\033[41;37m 开始下载翻墙脚本文件......\033[0m"
		sh /etc/storage/dnsmasq.d/hsfq_update.sh
	fi

	echo -e "\e[1;36m 添加自定义 hosts 启动路径 \e[0m"
	[ -f /var/log/dnsmasq.log ] && rm /var/log/dnsmasq.log
	[ -f /tmp/tmp_dnsmasq ] && rm /tmp/tmp_dnsmasq
	if [ ! -f "/etc/storage/dnsmasq/dnsmasq.conf" ]; then
		grep "storage" /etc/storage/dnsmasq/dnsmasq.conf
		if [ $? -eq 0 ]; then
			sed -i '/127.0.0.1/d' /etc/storage/dnsmasq/dnsmasq.conf
			sed -i '/log/d' /etc/storage/dnsmasq/dnsmasq.conf
			sed -i '/no-hosts/d' /etc/storage/dnsmasq/dnsmasq.conf
			sed -i '/strict-order/d' /etc/storage/dnsmasq/dnsmasq.conf
			sed -i '/1800/d' /etc/storage/dnsmasq/dnsmasq.conf	
			sed -i '/dnsmasq.d/d' /etc/storage/dnsmasq/dnsmasq.conf
		else
			echo -e "\033[41;37m 开始写入启动代码 \e[0m"
		fi
		echo "listen-address=${route_vlan},127.0.0.1
# 添加监听地址
# 开启日志选项
log-queries
log-facility=/var/log/dnsmasq.log
# 异步log,缓解阻塞，提高性能。默认为5，最大为100
log-async=50
# 关闭内置hosts，配合启用第三方hosts
no-hosts
# DNS服务器严格按顺序使用
strict-order
# 缓存最长时间
min-cache-ttl=1800
# 指定服务器'域名''地址'文件夹
conf-dir=/etc/storage/dnsmasq.d/conf/
# conf-file=/etc/storage/dnsmasq.d/conf/hosts_fq.conf
# 指定hosts解析'地址''域名'文件夹
addn-hosts=/etc/storage/dnsmasq.d/hosts" >> /tmp/tmp_dnsmasq.conf
		echo
		sort -n /tmp/tmp_dnsmasq.conf | uniq | sed -e "/# /d" >> /etc/storage/dnsmasq/dnsmasq.conf
		rm /tmp/tmp_dnsmasq.conf >/dev/null 2>&1
	else
		echo -e "\e[1;36m 添加自定义 hosts 启动路径 \e[0m"
		wget --no-check-certificate -t 20 -T 50 https://raw.githubusercontent.com/896660689/Hsfq/master/tmp_dnsmasq -qO /tmp/tmp_dnsmasq
		chmod 777 /tmp/tmp_dnsmasq && sh /tmp/tmp_dnsmasq
	fi

	if [ -f "/etc/storage/post_iptables_script.sh" ]; then
		echo -e "\e[1;36m 添加防火墙端口转发规则 \e[0m"
		sed -i '/DNAT/d' /etc/storage/post_iptables_script.sh
		sed -i '/iptables-save/d' /etc/storage/post_iptables_script.sh
		sed -i '$a /bin/iptables-save' /etc/storage/post_iptables_script.sh
	fi
	echo "/bin/iptables -t nat -A PREROUTING -p tcp --dport 53 -j DNAT --to $route_vlan" >> /etc/storage/post_iptables_script.sh
	echo "/bin/iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to $route_vlan" >> /etc/storage/post_iptables_script.sh
	if [ -f "/etc/storage/post_iptables_script.sh" ]; then
		sed -i '/resolv.conf/d' /etc/storage/post_iptables_script.sh
		sed -i '/restart_dhcpd/d' /etc/storage/post_iptables_script.sh
		sed -i '$a cp -f /etc/storage/dnsmasq.d/resolv.conf /tmp/resolv.conf' /etc/storage/post_iptables_script.sh
		sed -i '$a sed -i "/#/d" /tmp/resolv.conf;mv -f /tmp/resolv.conf /etc/resolv.conf' /etc/storage/post_iptables_script.sh
		sed -i '$a restart_dhcpd' /etc/storage/post_iptables_script.sh
	fi
	[ -f /tmp/fqhs_an.sh ] && rm -rf /tmp/fqhs_an.sh
	sleep 3
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "+                 installation is complete                 +"
	echo "+                                                          +"
	echo "+                     Time:`date +'%Y-%m-%d'`                      +"
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	sh /tmp/hsfq_script.sh
fi
echo