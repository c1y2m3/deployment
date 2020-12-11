#!/bin/sh

FRP_VERSION="0.33.0"
WORK_PATH=$(dirname $(readlink -f $0))
getIpAddress=$(curl -sS --connect-timeout 10 -m 60 https://www.bt.cn/Api/getIpAddress)
java_file="/usr/local/java"
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
	
	

