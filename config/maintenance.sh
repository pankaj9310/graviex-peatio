#!/bin/bash

if [ "$1" == "off" ]; then
  echo "switch off maintenance mode"
  ln -sf /home/graviex/graviex-exchange/config/nginx.conf /etc/nginx/conf.d/graviex.conf
  service nginx reload
else
  echo "switch on maintenance mode"
  ln -sf /home/graviex/graviex-exchange/config/nginx_maintenance.conf /etc/nginx/conf.d/graviex.conf
  service nginx reload
fi
