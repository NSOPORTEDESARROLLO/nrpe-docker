FROM		debian:stretch 
MAINTAINER	cnaranjo@nsoporte.com


#apt update/upgrade
RUN			apt-get update; \
			apt-get -y upgrade




#Instalando docker 
RUN			 apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common curl; \
			 cd /tmp/; \
			 curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - ; \
			 add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" ; \
			 apt-get update; \
			 apt-get -y install docker-ce


#Compiladores y dependencias 
RUN			 apt-get -y install build-essential make sudo python3 python3-pip wget telnet net-tools; \
			 apt-get -y install git perl nagios-nrpe-server nagios-nrpe-plugin; \
			 apt-get -y install monitoring-plugins nagios-plugins-contrib nagios-snmp-plugins libanyevent-perl


#Copy Files
COPY    	files/ns-start /usr/bin/
COPY  		files/nrpe.cfg /etc/nagios/
ADD   		files/procps.tgz /usr/src/
ADD         files/Asterisk-AMI-v0.2.8.tar.gz /tmp/


#Install Asterisk AMI
RUN			cd /tmp/Asterisk-AMI-v0.2.8; \
			perl Makefile.PL; \
			make; \
			make test; \
			make install; \
			rm -rf /tmp/Asterisk-AMI-v0.2.8



#Directory skel
RUN			mkdir /host; \
			mkdir /host/disk; \
			mkdir /host/disk/bootfs; \
			mkdir /host/disk/datafs; \
			mkdir /host/disk/optfs; \
			mkdir /host/disk/rootfs; \
			mkdir /host/disk/varfs; \
			mkdir /host/dev; \
			mkdir /host/proc; \
			mkdir /etc/nagios/config.d; \
			mkdir /custom; \
			mkdir /plugins; \
			mkdir /usr/lib/nagios/plugins/nsoporte; \
			mv /bin/ps /bin/ps-local; \
			ln -s /usr/src/procps/ps/pscommand /bin/ps



#Obteniendo plugins y archivos de configuracion
RUN			cd /tmp; \
			git clone https://github.com/NSOPORTEDESARROLLO/nsnagios-plugins.git; \
			cp -rvp /tmp/nsnagios-plugins/samples/* /etc/nagios/config.d/; \
			cp -rvp /tmp/nsnagios-plugins/plugins/* /usr/lib/nagios/plugins/nsoporte/; \
			rm -rf /tmp/nsnagios-plugins


#Plugins para el host
RUN			mkdir /opt/host_plugins; \
			cd /opt/host_plugins; \
			wget "https://raw.githubusercontent.com/HariSekhon/Nagios-Plugins/master/check_yum.py" -O check_yum.py; \
			cp /usr/lib/nagios/plugins/check_apt /opt/host_plugins	




#Permisos
RUN			chmod +x /usr/bin/ns-start; \
			chmod +x /usr/lib/nagios/plugins/nsoporte/*; \
			echo "nagios     ALL=(ALL) NOPASSWD:ALL" >>  /etc/sudoers






ENTRYPOINT [ "/usr/bin/ns-start" ]