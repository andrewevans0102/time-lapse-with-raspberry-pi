#!/bin/bash

# Modify the variables here based on your username and where you want to store the files
USERNAME="pi"
ADDRESS="camera.local"
OUTPUT_SOURCE="/home/pi/webcam"
MACBOOK_USERNAME=$USER
OUTPUT_DESTINATION="/Users/"$MACBOOK_USERNAME"/Desktop/webcam"

rm -rf $OUTPUT_DESTINATION

scp -r $USERNAME@$ADDRESS:$OUTPUT_SOURCE $OUTPUT_DESTINATION

open .