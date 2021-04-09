#!/bin/bash

# Make sure this script is run by root
if [ "$EUID" -ne 0 ] ; then 
    echo "Run as root!"
    exit
fi

# Watch if server is up, if not poweroff
SERVER_PID="$(mscs status | tail -n1 | cut -b 17-20)"
if [ !$SERVER_PID ] ; then
    echo "server inattivo, spegnimento..."
fi

exit 0
