FROM		debian:stretch 
MAINTAINER	cnaranjo@nsoporte.com


#apt update/upgrade
RUN			apt-get update; \
			apt-get -y upgrade


#Copy Files
Copy    	files/ns-start /usr/bin/
ADD   		files/procps.tgz /usr/src/
ADD         files/Asterisk-AMI-v0.2.8.tar.gz /tmp/


#Directory skel
RUN			mkdir /custom; \
			mkdir /plugins; \
			mkdir /usr/lib/nagios/plugins/nsoporte



#Instalando docker 
RUN			 apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common curl; \
			 cd /tmp/; \
			 curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - ; \
			 add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" ; \
			 apt-get update; \
			 apt-get -y install docker-ce


#Compiladores y dependencias 
RUN			 apt-get -y install build-essential make sudo python3 python3-pip wget telnet net-tools; \
			 apt-get -y install git perl nagios-nrpe-server nagios-nrpe-plugin; \
			 apt-get -y install monitoring-plugins nagios-plugins-contrib nagios-snmp-plugins








#Permisos
RUN			chmod +x /usr/bin/ns-start




ENTRYPOINT [ "/usr/bin/ns-start" ]