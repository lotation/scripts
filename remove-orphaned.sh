#!/bin/bash

for pkg in $(paru -Qdtq)
do
	paru -R "$pkg"
done

exit 0
