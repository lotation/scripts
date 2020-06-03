#!/bin/bash
gnome-terminal --tab --title="ubuntu update" --command="bash -c 'sudo apt -y update; sudo apt -y upgrade; exit; $SHELL'"
