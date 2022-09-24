#!/bin/bash

  id=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
  name=$(xprop -id $id | awk '/_NET_WM_NAME/{$1=$2="";print}' | sed -e 's/"//g' | sed -e 's/\\//g')

  echo "${name}                     "
