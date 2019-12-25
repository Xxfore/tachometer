Information
====
<br>This is sample application for af-steering-wheel-binding.
<br>At above of the screen will display usb-camera(UVC camera) video.
<br>At bottom of this screen will display the can information.
<br>Right now it can get VehicleSpeed,EngineSpeed,TransmissionMode information from af-steering-wheel-binding.
<br>Or you can change to use low-level-can-servcie.

* Hardware: Renesas m3ulcb
* Software: Daring Dab 4.0.0
* Application name: tachometer
* Test Device: Logitech c920r

How to compile and install
====
<br>	These is a sample recipe for tachometer, you can just add that recipes into your project and bitbake.
<br>	Sample Recipes: tachometer_git.bb

How to use
====
<br>1, If the camera has been connected, you can select the camera corresponding to the device ID, and set FPS ,
<br>pixel parameters, open ON/OFF switch on the right, you can see the camera display content.
<br>2, operation steering-wheel device corresponding function, you can see vehicle speed, engine speed, transmission mode changes.

Kernel configure
====
<br>You need to enable some kernel configure to enable usb camera.
* CONFIG_VIDEOBUF2_VMALLOC=y
* CONFIG_MEDIA_USB_SUPPORT=y
* CONFIG_USB_VIDEO_CLASS=y
* CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y

CAN data
====
* engine.speed
<br> canid: 1C4
<br> offset: 0
<br> bitsize: 16
<br> sample: cansend vcan0 1C4#FFFF000000000000

* vehicle.average.speed
<br> canid: 0B4
<br> offset: 40
<br> bitsize: 16
<br> sample: cansend vcan0 0B4#0000000000FFFF00

* fuel.level
<br> canid: 612
<br> offset: 40
<br> bitsize: 8
<br> sample: cansend vcan0 612#0000000000FF0000

* Transmission.SiftPosition.neutral
<br> canid: 3BC
<br> offset: 12
<br> bitsize: 1
<br> sample: cansend vcan0 3BC#0008000000000000

* Transmission.SiftPosition.driving
<br> canid: 3BC
<br> offset: 40
<br> bitsize: 1
<br> sample: cansend vcan0 3BC#0000000000800000

* Transmission.SiftPosition.parking
<br> canid: 3BC
<br> offset: 10
<br> bitsize: 1
<br> sample: cansend vcan0 3BC#0020000000000000
