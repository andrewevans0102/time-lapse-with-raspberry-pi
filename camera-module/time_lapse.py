from time import sleep
from picamera import PiCamera

# every 5 seconds for an hour
# 60 X 60 / 5 = 720

# enable camera on raspberry pi
# https://picamera.readthedocs.io/en/release-1.13/quickstart.html

# installation
# https://picamera.readthedocs.io/en/release-1.13/install.html

# recipes to get started
# https://picamera.readthedocs.io/en/release-1.13/recipes1.html#recipes1

camera = PiCamera()
camera.start_preview()
sleep(2)
for filename in camera.capture_continuous('/home/pi/webcam/{timestamp:%Y-%m-%d_%H%M%S}.jpg'):
    print('Captured %s' % filename)
    sleep(15)	