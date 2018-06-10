#!/bin/sh -x

./10_cp-dic.sh
./06_test_julius.sh &
sleep 5 && ./07_echo.py
 
