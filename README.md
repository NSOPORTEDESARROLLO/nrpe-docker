# Nrpe Service 

Nagios NRPE service on Docker container, it is used to monitoring host services and containers


## Volumes:

We used to mount host services on /host container folder ( Proc, dev, and disks )

- /host/bootfs: You can Mount /boot partition here to monitoring 
- /host/datafs: You can Mount /data partition here to monitoring
- /host/optfs: You can Mount /opt partition here to monitoring
- /host/rootfs: You can Mount /root partition here to monitoring
- /host/varfs: You can Mount /var partition here to monitoring
- /host/proc: /proc folder on host
- /custom: Where config files will be storaged, it must be "service_name.cfg" 
- /plugins: Custom plugins directory, you can use your custom plugins here
- /var/run/utmp: This file has logged users information 
- /var/run/docker.sock: Docker Socket to containers monitoring



## Custom plugins:

- check_asterisk
- check_calls_trunk.pl
- check_cpu
- check_dirsize.sh
- check_docker
- check_drbd
- check_freepbx_enabled
- check_ram
- check_yum.pl (https://raw.githubusercontent.com/HariSekhon/Nagios-Plugins/master/check_yum.py)