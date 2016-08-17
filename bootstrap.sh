#!/bin/bash

[[ $VCL_CONFIG == http* ]] && \
  curl -s $VCL_CONFIG > /etc/varnish/custom.vcl && \
  VCL_CONFIG="/etc/varnish/custom.vcl"

[[ $START_SCRIPT == http* ]] && \
  curl -s $START_SCRIPT > /start_script && \
  START_SCRIPT="/start_script" && \
  chmod +x $START_SCRIPT
if [ -n "$START_SCRIPT" ]; then
  $START_SCRIPT
fi

set -e

exec bash -c \
  "exec varnishd \
  -j unix,user=varnish \
  -F \
  -f $VCL_CONFIG \
  -s malloc,$CACHE_SIZE \
  $VARNISHD_PARAMS"
