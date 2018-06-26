#!/bin/sh -x

./run_julius.sh &

sleep 5 && ./rpi_echo.py

