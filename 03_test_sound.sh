#!/bin/sh 

if [ "x$1" = "x" ] ; then
   echo "Invalid argument."
   exit 1
fi

TMPFILE=/tmp/open_jtalk_tmp.wav

#HTS=/dev/shm/naist-jdic/tohoku-f01-neutral.htsvoice
#DIC_DIR=/dev/shm/naist-jdic
HTS=/usr/share/hts-voice/htsvoice-tohoku-f01/tohoku-f01-neutral.htsvoice
DIC_DIR=/var/lib/mecab/dic/open-jtalk/naist-jdic

echo "$1" | \
  open_jtalk \
  -m $HTS \
  -x $DIC_DIR \
  -ow $TMPFILE && \
  sudo aplay -q $TMPFILE && \
  rm -f $TMPFILE
