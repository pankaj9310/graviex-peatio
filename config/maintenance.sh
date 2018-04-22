#!/bin/bash

if [ "$1" == "off" ]; then
  echo "switch off maintenance mode"
  ln -sf /home/graviex/graviex-exchange/config/nginx.conf /etc/nginx/conf.d/graviex.conf
  mv /home/graviex/graviex-exchange/public/404.html.old /home/graviex/graviex-exchange/public/404.html
  service nginx reload
else
  echo "switch on maintenance mode"
  ln -sf /home/graviex/graviex-exchange/config/nginx_maintenance.conf /etc/nginx/conf.d/graviex.conf
  mv /home/graviex/graviex-exchange/public/404.html /home/graviex/graviex-exchange/public/404.html.old
  cp /home/graviex/graviex-exchange/public/503.html /home/graviex/graviex-exchange/public/404.html
  service nginx reload
fi
