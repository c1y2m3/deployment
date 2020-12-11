#!/bin/sh
FRP_VERSION="0.33.0"
WORK_PATH=$(dirname $(readlink -f $0))
getIpAddress=$(curl -sS --connect-timeout 10 -m 60 https://www.bt.cn/Api/getIpAddress)

if [ -f "/usr/local/frp/frps" ];then
	echo "=======================================================" &&\
	echo -e "检测到已安装程序,客户端默认配置："
	echo -e "\033[32mvi /usr/local/frp/frps.ini \033[0m" && \
	echo -e "[common]"
	echo  "server_addr = ${getIpAddress}"
	echo  "server_port = 443"
	echo -e "tls_enable = true"
	echo -e "token = edbace9473a3"
	echo -e "\r"
	echo -e "[random]"
	echo -e "type = tcp"
	echo -e "plugin = socks5"
	echo -e "plugin_user = 45be5c0b1982"
	echo -e "plugin_passwd = 18b3048e2128"
	echo -e "remote_port = 8999"
	echo -e "use_encryption = true"
	echo -e "use_compression = true"
	echo "=======================================================" 
else
	# 创建frp文件夹
	mkdir -p /usr/local/frp && \
	# 下载并移动frps文件
	wget -P ${WORK_PATH} https://7yu4k.oss-cn-beijing.aliyuncs.com/frps_${FRP_VERSION}.tar.gz  >/dev/null 2>&1 && \
	tar -zxvf frps_${FRP_VERSION}.tar.gz  >/dev/null 2>&1 && \
	cd frps_${FRP_VERSION} && \
	chmod u+x frps && \
	mv frps /usr/local/frp && mv frps.ini /usr/local/frp \
	# 下载frps.in和frps.service
	wget -P /lib/systemd/system https://7yu4k.oss-cn-beijing.aliyuncs.com/frps.service  >/dev/null 2>&1 && \
	systemctl daemon-reload && \
	# 启动frps
	sudo systemctl start frps && \
	sudo systemctl enable frps && \
	# 删除多余文件
	cd ${WORK_PATH} && \
	rm -rf frps_${FRP_VERSION} frps_${FRP_VERSION}.tar.gz install-frp.sh
	echo "=======================================================" &&\
	echo -e "\033[32m安装成功,确认格式及配置正确无误!\033[0m" && \
	echo -e "\033[32mvi /usr/local/frp/frps.ini \033[0m" && \
	echo -e "[common]"
	echo  "server_addr = ${getIpAddress}"
	echo  "server_port = 443"
	echo -e "tls_enable = true"
	echo -e "token = edbace9473a3"
	echo -e "\r"
	echo -e "[random]"
	echo -e "type = tcp"
	echo -e "plugin = socks5"
	echo -e "plugin_user = 45be5c0b1982"
	echo -e "plugin_passwd = 18b3048e2128"
	echo -e "remote_port = 8999"
	echo -e "use_encryption = true"
	echo -e "use_compression = true"
	echo "=======================================================" 
fi