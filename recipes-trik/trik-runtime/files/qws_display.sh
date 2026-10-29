#!/bin/sh
if [ x$DISPLAY = x ]
then
        DISPLAY=:0
fi
export DISPLAY
