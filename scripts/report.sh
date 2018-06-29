#!/bin/sh -x

F=result.log

echo `date` | tee $F

uname -a 2>&1| tee -a $F

julius --version 2>&1| tee -a $F

open_jtalk 2>&1| tee -a $F

opencv_version 2>&1| tee -a $F

lsblk 2>&1| tee -a $F

python --version 2>&1| tee -a $F

python3 --version 2>&1| tee -a $F

dpkg -l julius opencv open-jtalk 2>&1| tee -a $F

B=`which bazel`
if [ "x$B" != "x" ] ; then
    sha256sum $B 2>&1| tee -a $F
fi

