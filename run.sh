#!/bin/sh -x

export TF_CPP_MIN_LOG_LEVEL=2

./rpi_echo.py &
./run_julius.sh &
