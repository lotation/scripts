#!/bin/bash

SRC=$(echo "$1" | cut -f 1 -d '.')

gcc -Wall -Wextra -pedantic -o $SRC $SRC.c

if [ -x "$SRC" ] ; then
  ./$SRC
else
  chmod +x "$SRC" && ./$SRC
fi

echo
