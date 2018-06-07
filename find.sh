#!/bin/sh

grep msg.find 07_echo.py | \
    perl -pe 's/^\s+//; s/elif//; s/msg.find//g; s/-1//g; s/://g; s/>//g; s/if//; s/ +/ /g;' 
