#!/bin/sh 

if [ "x$1" = "x" ] ; then
   echo "Invalid argument."
   exit 1
fi

TMPFILE=/tmp/open_jtalk_tmp.wav

echo "$1" | \
  open_jtalk \
  -m /usr/share/hts-voice/htsvoice-tohoku-f01/tohoku-f01-neutral.htsvoice \
  -x /dev/shm/naist-jdic \
  -ow $TMPFILE && \
  sudo aplay -q $TMPFILE && \
  rm -f $TMPFILE
 
#  -x /var/lib/mecab/dic/open-jtalk/naist-jdic \

