#!/bin/bash

FREE_SPACE=$($(top -l 1 | grep PhysMem | awk '{print $10}' | sed 's/M//'))
TH=500

if [[ $FREE_SPACE -lt $TH ]]
then
    echo "ram is running low"
else
    echo "ram space is sufficient -$FREE_SPACE M "
fi

