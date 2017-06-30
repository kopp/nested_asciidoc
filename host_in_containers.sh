#!/usr/bin/env bash

# publish the content of this folder using docker containers


volume_name=asciidoctor_web_content
nginx_name=nginx-for-asciidoctor
exposed_port_no=6568

# make sure, that the volume is present
if ! docker volume ls | grep -q " ${volume_name}$"
then
    echo Creating docker volume $volume_name
    docker volume create $volume_name
fi

# launch nginx if not already running
nginx_ps=$(docker ps -a | grep " ${nginx_name}$")
if [ -z "$nginx_ps" ]
then
    # if not running at all, start it
    echo starting nginx daemon $nginx_name
    docker run --name $nginx_name -p $exposed_port_no:80 -v $volume_name:/usr/share/nginx/html:ro -d nginx
else
    if echo $nginx_ps | grep -q Exited
    then
        echo starting stopped nginx daemon $nginx_name
        docker start $nginx_name
    fi
fi

# check IP address
echo -n Access content on IP addres
docker inspect $nginx_name | grep IPAddress | tail -n 1
echo Or access on this host with port $exposed_port_no

# actually run the container to generate content
docker run --rm -v $(pwd):/documents/ -v $volume_name:/generated/ asciidoctor/docker-asciidoctor ./build_it.sh /generated
