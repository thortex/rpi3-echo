#!/bin/sh

kill_p() 
{
    echo "$1"
    x=`ps aux | grep $1 | grep -v grep | awk '{print $2;}'`
    
    if [ "$x" != "" ] ; then
	echo Killing process...
	kill $x
	echo Killed.
    fi
}

kill_p run.sh;
kill_p rpi_echo.py;
kill_p julius.jconf;


