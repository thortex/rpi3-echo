#!/bin/sh

grep '"msg":' 07_echo.py | \
    perl -pe 's/^\s+//; s/elif//; s/"msg"://g; s/-1//g; s/://g; s/>//g; s/if//; s/ +/ /g;' 
