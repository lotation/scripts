#!/bin/bash

if [ "$(echo "9000 * 9000" | bc -ql)" -gt "$(echo "9002 * 8998" | bc -ql)" ] ; then 
        echo "Yes"
fi
