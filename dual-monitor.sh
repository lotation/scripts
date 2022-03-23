#!/bin/bash

MONITOR=$(xrandr | grep HDMI | cut -f1 -d" ")
LAPTOP=$(xrandr | grep primary | cut -f1 -d" ")

if [ "$MONITOR" ]; then
	xrandr --output $MONITOR --primary
	xrandr --output $LAPTOP --auto --right-of $MONITOR
fi
