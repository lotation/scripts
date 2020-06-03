#!/bin/bash

DIR=/home/lotation/Documents/GitHub/des

#clear
cd $DIR
git add .
git commit -m "updated some stuff"
git push origin master

echo -e "Push completed successfully."

exit
