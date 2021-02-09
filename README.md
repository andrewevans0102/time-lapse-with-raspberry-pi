# Time Lapse with Raspberry Pi

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/by9RYVOoAqg/0.jpg)](https://www.youtube.com/watch?v=by9RYVOoAqg)

This project creates time lapse videos with a [Raspberry Pi Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/) and a [Logitech USB Webcam](https://www.amazon.com/Logitech-C270-720pixels-Black-webcam/dp/B01BGBJ8Y0/ref=sr_1_12?dchild=1&keywords=logitech+webcam&qid=1612213441&sr=8-12). I created the above YouTube video of a recent snowfall we had here in Richmond, Va. Check out this video and more on the [Rhythm and Binary YouTube Channel](https://www.youtube.com/channel/UCvAKKewP_o2l3XnwDzSxftw).

This project also has instructions on how to use the [Raspberry Pi Camera Module](https://www.raspberrypi.org/products/camera-module-v2/) to do the same time lapse.

There is a blog post that walks through most of this project at [https://rhythmandbinary.com/post/2021-02-01-creating-a-time-lapse-video-with-a-raspberry-pi](https://rhythmandbinary.com/post/2021-02-01-creating-a-time-lapse-video-with-a-raspberry-pi).

There is also an accompanying video that explains this more in depth on YouTube.

## Required Materials

- [Raspberry Pi Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/)
- [USB Power Supply for Raspberry Pi](https://www.amazon.com/CanaKit-Raspberry-Supply-Adapter-Listed/dp/B00MARDJZ4/ref=sr_1_3?dchild=1&keywords=raspberry+pi+usb+power+supply&qid=1612213467&sr=8-3)
- [16 GB SD Card](https://www.amazon.com/Gigastone-10-Pack-Camera-MicroSD-Adapter/dp/B089288NQK/ref=sr_1_9?dchild=1&keywords=16gb+micro+sd+card&qid=1612213510&sr=8-9)
- [USB Webcam](https://www.amazon.com/Logitech-C270-720pixels-Black-webcam/dp/B01BGBJ8Y0/ref=sr_1_12?dchild=1&keywords=logitech+webcam&qid=1612213441&sr=8-12).
- [Raspberry Pi Camera Module (only if you want to use PiCamera Library)](https://www.raspberrypi.org/products/camera-module-v2/)
- [Raspberry Pi Zero W Camera Module Cable (only if you want to use PiCamera Library)](https://www.amazon.com/dp/B07SM6JTTM/ref=cm_sw_r_tw_dp_M3GZDDAA80NNZWHY6K8Z?_encoding=UTF8&psc=1)

## Project Setup with Shell Scripts

1. Setup the Raspberry Pi Zero W to have SSH and be headless

- See [HEADLESS_SETUP](./HEADLESS_SETUP.md)

2. Install `fswebcam` on the Raspberry Pi

```bash
sudo apt install fswebcam
```

3. Install `mencoder` on the Raspberry Pi

```bash
sudo apt install mencoder
```

4. Create Shell script to use `fswebcam` (see [TAKE_PICTURE.sh](./shell-scripts/TAKE_PICTURE.sh))

- [https://www.raspberrypi.org/documentation/usage/webcams/](https://www.raspberrypi.org/documentation/usage/webcams/)

```sh
#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H%M")

fswebcam -r 1280x720 --no-banner /home/pi/webcam/$DATE.jpg
```

5. Create cronjob to take a picture every minute (run `crontab -e` on the pi)

- [https://www.raspberrypi.org/documentation/usage/webcams/](https://www.raspberrypi.org/documentation/usage/webcams/)

6. Turn on shell script for however long you want to save your time lapse

7. Go into the folder that you've stored your pictures and create a map with `ls *.jpg > stills.txt`

8. Run `mencoder` inside the folder where you've saved your files to create a video from the still images

```bash
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/9:vbitrate=8000000 -vf scale=1920:1080 -o timelapse.avi -mf type=jpeg:fps=24 mf://@stills.txt
```

9. Copy the video file over to your primary computer (in my case it was a MacBook)

```bash
scp -r pi@<pi_address>:/home/pi/webcam /Users/<your_username>/webcam
```

10. Install `ffmpeg` to convert AVI file over to MP4 (I used a MacBook so I installed it with [homebrew](https://brew.sh/))

```bash
brew install ffmpeg
```

11. Convert AVI file over to MP4 with ffmpeg

```bash
ffmpeg -i timelapse.avi timelapse.mp4
```

## Project Setup with PiCamera Library

1. Setup the Raspberry Pi Zero W to have SSH and be headless

- See [HEADLESS_SETUP](./HEADLESS_SETUP.md)

2. Purchase the [Raspberry Pi Camera Module](https://www.raspberrypi.org/products/camera-module-v2/) and [Raspberry Pi Zero W Camera Module Cable](https://www.amazon.com/dp/B07SM6JTTM/ref=cm_sw_r_tw_dp_M3GZDDAA80NNZWHY6K8Z?_encoding=UTF8&psc=1)

3. Connect the Raspberry Pi Camera Module to the Raspberry Pi

4. Setup the PiCamera library to run on your Raspberry Pi with [installation instructions](https://picamera.readthedocs.io/en/release-1.13/install.html)

5. Write your first python script that runs the camera (use this to make sure it is working), see [first_picture.py](./camera-module/first_picture.py)

6. Write your second python script that uses the "capture continuous" method to continually take pictures. see [time_lapse.py](./camera-module/time_lapse.py)

7. Create a service that will run your python script in the `/home/pi` folder on your Raspberry Pi, see [timeLapse.service](./systemd/timeLapse.service)

8. Copy your service over to the Raspberry Pi's `etc` folder with

```bash
sudo cp timeLapse.service /etc/systemd/system/timeLapse.service
```

9. Start your service with

```bash
sudo systemctl start timeLapse.service
```

10. Verify that pictures are being written out to the `/home/pi/webcam` folder

11. Wait for however long you want to do the time lapse

12. When you're ready to stop taking the pictures, stop the service with

```bash
sudo systemctl stop timeLapse.service
```

13. Use the helper script [COPY_FILES_BUILD_LOCAL.sh](./shell-scripts/COPY_FILES_BUILD_LOCAL.sh) to copy the images over to your MacBook and then use `ffmpeg` to convert the images into a video

14. Check out the generated MP4 files and enjoy!

## Helpful Scripts

I scripted out steps 7-8 above with [CREATE_VIDEO.sh](./shell-scripts/CREATE_VIDEO.sh). This creates a fast and slow version. The fast version is 24 frames per second. The slow version is 4 frames per second.

I scripted out steps 9-11 above with [COPY_LOCAL.sh](./shell-scripts/COPY_LOCAL.sh). This creates a folder inside the `Pictures` folder on a MacBook. The output files are then stored in a directory named for the date and time of the download.

If you wanted to see the source files that the Raspberry Pi used to create the video, use the [COPY_PICTURES.sh](./shell-scripts/COPY_PICTURES.sh) script to put them on your MacBook.

If you want to use the Raspberry Pi Camera Module and PiCamera Library, use the [COPY_FILES_BUILD_LOCAL.sh](./shell-scripts/COPY_FILES_BUILD_LOCAL.sh) script to copy the generated images over to your MacBook.

## mencoder

This project uses `mencoder` to convert JPEG files into an AVI formatted video. When using `mencoder` everything is configurable. I found if I used a slower frame rate, I seemed to get a nicer time lapse. You can modify this with the `fps` setting as you see here:

```bash
# faster with 24 fps rate
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/9:vbitrate=8000000 -vf scale=1920:1080 -o /home/pi/saved/$DATE.avi -mf type=jpeg:fps=24 mf://@stills.txt

# slower with 4 fps rate
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/9:vbitrate=8000000 -vf scale=1920:1080 -o /home/pi/saved/$DATE.avi -mf type=jpeg:fps=4 mf://@stills.txt
```

I have two examples where you can see the difference.

- The faster frame rate is [examples/fast.mp4](./examples/fast.mp4)
- The slower frame rat is [examples/slow.mp4](./examples/slow.mp4)

I included both the AVI and MP4 files for reference.

## Helpful Information

- This post on stackexchanged helped to understand the commands to convert AVI file copied from the Raspberry Pi into an MP4 format
  [https://unix.stackexchange.com/questions/35746/encode-with-ffmpeg-using-avi-to-mp4](https://unix.stackexchange.com/questions/35746/encode-with-ffmpeg-using-avi-to-mp4)

- This was the official Raspberry Pi documentation on creating a time lapse with raspicam
  [https://www.raspberrypi.org/documentation/usage/camera/raspicam/timelapse.md](https://www.raspberrypi.org/documentation/usage/camera/raspicam/timelapse.md)

- Post on some common SCP commands with an SSH connection
  [https://rhythmandbinary.com/post/2020-12-31-using-ssh](https://rhythmandbinary.com/post/2020-12-31-using-ssh)

- This is the official Raspberry Pi page on using USB webcams instead of the official camera module
  [https://www.raspberrypi.org/documentation/usage/webcams/](https://www.raspberrypi.org/documentation/usage/webcams/)

- This is the official Raspberry Pi tutorial on using the Camera Module [https://projects.raspberrypi.org/en/projects/getting-started-with-picamera](https://projects.raspberrypi.org/en/projects/getting-started-with-picamera)

- This is the official Raspverry Pi documentation on using `systemd` to create services [https://www.raspberrypi.org/documentation/linux/usage/systemd.md](https://www.raspberrypi.org/documentation/linux/usage/systemd.md)
