#!/bin/bash

rm -rf /home/pi/output

mkdir /home/pi/output

cp -avr /home/pi/webcam /home/pi/output/images

cd /home/pi/output/images

ls *.jpg > stills.txt

# fast
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/9:vbitrate=8000000 -vf scale=1920:1080 -o /home/pi/output/VIDEO_FAST.avi -mf type=jpeg:fps=24 mf://@stills.txt

# slow
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/9:vbitrate=8000000 -vf scale=1920:1080 -o /home/pi/output/VIDEO_SLOW.avi -mf type=jpeg:fps=4 mf://@stills.txt