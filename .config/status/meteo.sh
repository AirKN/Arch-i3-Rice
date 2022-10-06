#!/bin/bash


echo -n ☔ $(cat ~/.weatherreport | sed -n 14p | sed -e 's/^[[^m]*m//g' | grep -o "[0-9]*%" | sort -n | sed -e '$!d')

echo -n ' '

echo -n $(cat ~/.weatherreport | sed -n 11p| sed -e 's/^[[^m]*m//g;s/ /\n/g;s/°C//g;/^s*$/d' | grep -o "[0-9]*" | sort -n | sed -e 1b -e '$!d'| tr '\n' ' ' | awk '{print " 🥶",$1 "°"," 🌞",$2 "°"}')
