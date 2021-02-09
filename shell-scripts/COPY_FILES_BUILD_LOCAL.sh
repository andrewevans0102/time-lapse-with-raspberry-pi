#!/bin/bash

# Modify the variables here based on your username and where you want to store the files
USERNAME="pi"
ADDRESS="camera.local"
FOLDER_SOURCE="/home/pi/webcam/"
FOLDERNAME="TIME_LAPSE/"
MACBOOK_USERNAME=$USER
FOLDER_DESTINATION="/Users/"$MACBOOK_USERNAME"/Desktop/"$FOLDERNAME
DATE=$(date +"%Y-%m-%d_%H%M")
FAST_VIDEO=$FOLDER_DESTINATION$DATE"/videos/fast.mp4"
SLOW_VIDEO=$FOLDER_DESTINATION$DATE"/videos/slow.mp4"

# copy images over to MacBook
scp -r $USERNAME@$ADDRESS:$FOLDER_SOURCE $FOLDER_DESTINATION"2021-02-06_0746/webcam"

cd "/Users/"$MACBOOK_USERNAME"/Desktop/TIME_LAPSE/2021-02-06_0746/videos"

ffmpeg -framerate 24 -pattern_type glob -i $FOLDER_DESTINATION"2021-02-06_0746/webcam/*.jpg" -s:v 1440x1080 -c:v libx264 -crf 17 -pix_fmt yuv420p fast.mp4

ffmpeg -framerate 4 -pattern_type glob -i $FOLDER_DESTINATION"2021-02-06_0746/webcam/*.jpg" -s:v 1440x1080 -c:v libx264 -crf 17 -pix_fmt yuv420p slow.mp4
