#!/bin/sh -x

dst=/dev/shm/naist-jdic/
mkdir -p $dst

cp /var/lib/mecab/dic/open-jtalk/naist-jdic/*.* $dst
cp /usr/share/hts-voice/htsvoice-tohoku-f01/tohoku-f01-neutral.htsvoice $dst

dst=/dev/shm/julius
mkdir -p $dst
cp julius-kits/dictation-kit-v4.4/model/lang_m/bccwj.60k.bingram $dst
cp julius-kits/dictation-kit-v4.4/model/lang_m/bccwj.60k.htkdic $dst
cp julius-kits/dictation-kit-v4.4/model/phone_m/jnas-tri-3k16-gid.binhmm $dst
cp julius-kits/dictation-kit-v4.4/model/phone_m/logicalTri-3k16-gid.bin $dst
