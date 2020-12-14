#!/bin/sh
FRP_VERSION="0.33.0"
WORK_PATH=$(dirname $(readlink -f $0))
getIpAddress=$(curl -sS --connect-timeout 10 -m 60 https://www.bt.cn/Api/getIpAddress)
java_file="/usr/local/java"

install_frp() {
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

}


install_cs() {
	if [ ! -d "$java_file" ];
	then
	 mkdir $java_file
	fi

	cd /usr/local/java
	if [ ! -f "jre-8u271-linux-x64.tar.gz" ];
	then
	 wget -P /usr/local/java/ https://7yu4k.oss-cn-beijing.aliyuncs.com/jre-8u271-linux-x64.tar.gz   >/dev/null 2>&1 
	fi

	if [ ! -d "jre1.8.0_271" ];
	then
	 tar -xvf /usr/local/java/jre-8u271-linux-x64.tar.gz   >/dev/null 2>&1 
	fi

	#set environment
	if [ -z $JAVA_HOME ];
	then 
	 echo " " >> /etc/profile
	 echo "#set jdk8 environment" >> /etc/profile
	 echo "export JAVA_HOME=/usr/local/java/jre1.8.0_271" >> /etc/profile
	 echo "PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile
	fi
	source /etc/profile
	echo "=======================================================" &&\
	echo "               jdk is installed !"
	echo "=======================================================" &&\

	function generate_passwd {
		(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c10) 2>/dev/null
	}

	server_passwd=$(generate_passwd)

	if [ -f "/usr/local/cs4/cobaltstrike.jar" ];then
		echo -e "检测到已安装程序,请手动启动！"
		echo -e "\033[32mnohup bash /usr/local/cs4/teamserver.sh & \033[0m" 
	else
		mkdir -p /usr/local/cs4 && \
		wget -P /usr/local/cs4 https://7yu4k.oss-cn-beijing.aliyuncs.com/cs4.tar.gz   >/dev/null 2>&1  && \
		cd /usr/local/cs4/ && \
		tar -zxvf cs4.tar.gz >/dev/null 2>&1  && \
		cd cs && \
		echo java -XX:ParallelGCThreads=4 -Dcobaltstrike.server_port=3389 -Djavax.net.ssl.keyStore=/usr/local/cs4/cobaltstrike.store -Djavax.net.ssl.keyStorePassword=123456 -server -XX:+AggressiveHeap -XX:+UseParallelGC -classpath /usr/local/cs4/cobaltstrike.jar server.TeamServer ${getIpAddress} $server_passwd > teamserver.sh
		chmod u+x * && \
		mv * /usr/local/cs4 && \
		nohup bash /usr/local/cs4/teamserver.sh >/dev/null 2>&1  &
		cd ${WORK_PATH} && \
		rm -rf cs cs4.tar.gz 
		echo -e "\033[32mCobaltStrike启动成功,确认格式及配置正确无误!\033[0m" && \
		echo -e "\033[32mnohup bash /usr/local/cs4/teamserver.sh & \033[0m" && \
		echo  "server_addr = ${getIpAddress}"
		echo  "server_port = 3389"
		echo  "server_passwd = $server_passwd"
	fi
}

if [[ $1 = "frp" ]]; 

then     

install_frp

fi


if [[ $1 = "cs" ]]; 

then     

install_cs

fi
