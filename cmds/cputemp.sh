#!/bin/sh

x=`vcgencmd measure_temp | sed -e "s/temp=//; s/'C//;"`

scripts/jtalk.sh "現在のCPU温度は${x}度です。"
