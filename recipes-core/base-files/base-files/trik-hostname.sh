#!/bin/sh
#Set/reset hostname from MAC

TRIK_HOSTNAME_DIR=/etc/trik

if [ ! -d ${TRIK_HOSTNAME_DIR} ]; then
        mkdir -p ${TRIK_HOSTNAME_DIR}
fi
if [ ! -f ${TRIK_HOSTNAME_DIR}/hostname ]; then
        echo "trik-$(tr -d ':' < /sys/class/net/wlan0/address | tail -c 7 )" > ${TRIK_HOSTNAME_DIR}/hostname
fi

if [ ! -L /etc/hostname ]; then
        ln -s -f ${TRIK_HOSTNAME_DIR}/hostname /etc/hostname
fi
