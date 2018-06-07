#!/bin/sh 

MONTH=`date +%-m`
DAY=`date +%-d`
DOW=`date +%-A`

STR="きょうは、${MONTH}月${DAY}日、${DOW}です。"

./03_test_sound.sh ${STR}

