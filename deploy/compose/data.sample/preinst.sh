#!/bin/sh

set -e

for i in /preinst.d/* ; do
        [ -d $i ] && continue
        if [ -x $i ]; then
                log-output -t preinst.sh /bin/echo $i
                $i
        fi
done
