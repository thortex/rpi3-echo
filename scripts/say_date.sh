#!/bin/sh 

MONTH=`date +%-m`
DAY=`date +%-d`
DOW=`date +%-A`

STR="きょうは、${MONTH}月${DAY}日、${DOW}です。"

script/jtalk.sh ${STR}

