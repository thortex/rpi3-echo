#!/bin/sh

HOUR=`date +%-H`
MINUTE=`date +%-M`

STR="現在の時刻は、${HOUR}時${MINUTE}分です。"

script/jtalk.sh ${STR}

