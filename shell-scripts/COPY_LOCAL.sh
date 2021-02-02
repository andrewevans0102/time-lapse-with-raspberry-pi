#!/bin/bash

# Modify the variables here based on your username and where you want to store the files
USERNAME="pi"
ADDRESS="camera.local"
OUTPUT_SOURCE="/home/pi/output/"
FOLDERNAME="Snow/"
MACBOOK_USERNAME=$USER
OUTPUT_DESTINATION="/Users/"$MACBOOK_USERNAME"/Pictures/"$FOLDERNAME
DATE=$(date +"%Y-%m-%d_%H%M")

# create folder in pictures for this video
mkdir $OUTPUT_DESTINATION$DATE

# copy the fast video first
scp $USERNAME@$ADDRESS:$OUTPUT_SOURCE"/VIDEO_FAST.avi" $OUTPUT_DESTINATION$DATE"/VIDEO_FAST.avi"

# copy the slow video second
scp $USERNAME@$ADDRESS:$OUTPUT_SOURCE"/VIDEO_SLOW.avi" $OUTPUT_DESTINATION$DATE"/VIDEO_SLOW.avi"

cd $OUTPUT_DESTINATION$DATE

# create the fast video in MP4 format
ffmpeg -i VIDEO_FAST.avi VIDEO_FAST.mp4

# create the slow video in MP4 format
ffmpeg -i VIDEO_SLOW.avi VIDEO_SLOW.mp4

