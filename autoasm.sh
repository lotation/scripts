#!/bin/bash
set -e

SRC=$(echo "$1" | cut -f 1 -d '.')

as $SRC.s -32 -o $SRC.o && ld $SRC.o -m elf_i386 -o $SRC

if [ -x "$SRC" ] ; then
  ./$SRC
else
  chmod +x "$SRC" && ./$SRC
fi

echo
