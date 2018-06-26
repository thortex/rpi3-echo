#!/bin/bash 

FILES=`find /usr/local/lib/python3.5/dist-packages/tensorflow/ -name '*.so'`
D=deps.tmp
echo -n '' > $D
for file in $FILES
do
    echo "Checking [$file] .."
    ldd $file >> $D
done

DEPS=`cat $D | \
    perl -pe 's/^.*? => //; s/\(0x.*?\)//; s/ //g; s/\t//g;' | \
    sort -u | \
    grep -v linux-vdso.so.1`
rm -f $D

R=requires.tmp
for dep in $DEPS
do
    echo "Checking [$dep] .."
    dpkg -S $dep >> $R
done

RESULT=release/install_requires_related2tensorflow.sh
echo '#!/bin/sh -x' > $RESULT
echo 'sudo apt-get install \' >> $RESULT
chmod +x $RESULT

cat ${R} | \
    grep -v ^tensorflow | \
    perl -pe 's/:.*?$//;' | \
    sort -u | \
    sed -e 's/$/ \\/;' >> $RESULT

echo ' ' >> $RESULT

rm -f ${R}
