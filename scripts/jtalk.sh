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

card_id=`(LANG=C aplay -l) |grep card |grep bcm2835 |awk '{print $2;}'|head -1 |sed -e 's/://;'`

echo "$1" | \
  open_jtalk \
  -m $HTS \
  -x $DIC_DIR \
  -ow $TMPFILE && \
  sudo aplay -D hw:$card_id,0 -q $TMPFILE && \
  rm -f $TMPFILE
