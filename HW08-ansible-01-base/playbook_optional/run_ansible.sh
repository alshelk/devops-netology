#!/usr/bin/env bash

function dockerrs {
  declare -A hosts=([fedora_last]=pycontribs/fedora [centos7]=pycontribs/centos:7 [ubuntu]=pycontribs/ubuntu)
  for h in ${!hosts[@]}; do
    if [ "$1" = "run" ]; then
      /usr/bin/docker run --rm -it  -d --name $h ${hosts[$h]}
    else
      /usr/bin/docker stop $h
    fi
  done
}

if [ -n "$1" ]
then
  dockerrs $1
else
  dockerrs run
  /usr/bin/docker ps
  ansible-playbook -i inventory/prod.yml site.yml
  dockerrs stop
fi

/usr/bin/docker ps -a