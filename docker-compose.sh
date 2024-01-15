#!/bin/bash

SERVICE_NAME="nrpe"
IMAGE="nsoporte/nrpe:latest"
SERVICE_DATA_STORAGE="/data/apps/nrpe"
ARG1=$1
ARG2=$2


function help
{

    echo "docker-compose.sh up/down -params     Example: docker-compose.sh up -d"

}


function up
{

    if [ "$ARG2" = "" ];then
        ARG2="-it" 
    fi

    docker run --name $SERVICE_NAME --net host  \
        -v  /etc/localtime:/etc/localtime:ro \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /etc/issue:/etc/issue.docker:ro \
        -v /var/run/utmp:/var/run/utmp \
        -v /proc:/host/proc:ro \
        -v /data/apps/nrpe/custom:/custom \
        -v /data/apps/nrpe/plugins:/plugins \
        -v /:/host/rootfs:ro \
	    -v /var:/host/varfs:ro \
        -v /home:/host/homefs:ro \
        --restart unless-stopped $ARG2 $IMAGE

}


function down
{

    docker stop $SERVICE_NAME
    docker rm $SERVICE_NAME

}



case $ARG1 in
  up)
    up
  ;;
  down)
    down
  ;;
  *)
    help
  ;;
esac