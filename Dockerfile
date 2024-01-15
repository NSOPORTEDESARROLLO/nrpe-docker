FROM		debian:bullseye
MAINTAINER	cnaranjo@nsoporte.com


#Copy Files
COPY    	files/ns-start /usr/bin/
COPY  		files/nrpe.cfg /etc/nagios/
ADD   		files/procps.tgz /usr/src/
ADD         files/Asterisk-AMI-v0.2.8.tar.gz /tmp/


#Instalando docker 
RUN		apt-get update; apt-get -y upgrade; \
		apt-get -y install apt-transport-https ca-certificates curl \ 
		gnupg2 software-properties-common curl; \
		cd /tmp/; \
		curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - ; \
		add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" ; \
		apt-get update; \
		apt-get -y install docker-ce build-essential make sudo python3 \
		python3-pip wget telnet net-tools git perl nagios-nrpe-server \
		nagios-nrpe-plugin monitoring-plugins nagios-plugins-contrib \
		nagios-snmp-plugins libanyevent-perl; \
		# Folder Skell 
		mkdir -p  /host/bootfs \
		/host/datafs \
		/host/optfs \
		/host/rootfs \
		/host/varfs \
		/host/homefs \
		/host/dev \
		/host/proc \
		/etc/nagios/config.d \
		/custom \
		/plugins  \
		/usr/lib/nagios/plugins/nsoporte; \
		# Proc Plugin
		mv /bin/ps /bin/ps-local; \
		ln -s /usr/src/procps/ps/pscommand /bin/ps; \
		# Install Asterisk AMI
		cd /tmp/Asterisk-AMI-v0.2.8; \
		perl Makefile.PL; \
		make; \
		make test; \
		make install; \
		rm -rf /tmp/Asterisk-AMI-v0.2.8; \
		#Obteniendo plugins y archivos de configuracion
		cd /tmp; \
		git clone https://github.com/NSOPORTEDESARROLLO/nsnagios-plugins.git; \
		cp -rvp /tmp/nsnagios-plugins/samples/* /etc/nagios/config.d/; \
		cp -rvp /tmp/nsnagios-plugins/plugins/* /usr/lib/nagios/plugins/nsoporte/; \
		rm -rf /tmp/nsnagios-plugins; \
		#Plugins para el host
		mkdir /opt/host_plugins; \
		cd /opt/host_plugins; \
		wget "https://raw.githubusercontent.com/HariSekhon/Nagios-Plugins/master/check_yum.py" -O check_yum.py; \
		cp /usr/lib/nagios/plugins/check_apt /opt/host_plugins; \	
		#Permisos
		chmod +x /usr/bin/ns-start; \
  		chmod +x /usr/lib/nagios/plugins/nsoporte/*; \
 		echo "nagios     ALL=(ALL) NOPASSWD:ALL" >>  /etc/sudoers

ENTRYPOINT [ "/usr/bin/ns-start" ]