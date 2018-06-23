#!/bin/sh 
(LANG=C arecord -l) | grep card | awk '{print $2;}' | sed -e 's/://;'
