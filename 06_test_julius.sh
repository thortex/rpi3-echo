#!/bin/sh -x

card_id=`(LANG=C arecord -l) |grep card |grep C-Media |awk '{print $2;}' |sed -e 's/://;'`

echo $card_id

(ALSADEV=hw:$card_id,0 julius -C 06_test_julius.jconf)
