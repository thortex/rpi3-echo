#!/bin/sh -x

D="C-Media"
card_id=`(LANG=C arecord -l) |grep card |grep $D |awk '{print $2;}' |sed -e 's/://;'`

echo $card_id

(ALSADEV=hw:$card_id,0 julius -C julius.jconf)
