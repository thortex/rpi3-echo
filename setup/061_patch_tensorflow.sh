#!/bin/sh -x
D=/usr/local/lib/python3.5/dist-packages/tensorflow/python/framework/
F=${D}op_def_registry.py
x=`grep PeriodicResample $F`
if [ "x$x" = "x" ] ; then
    sudo sed -i 's/assert/if op_def.name == "PeriodicResample": continue\n      assert/;' $F
fi

