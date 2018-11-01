# iot-nodemcu

IoT scripts for ESP8266 flashed with NodeMCU.

Use custom build of NodeMCU https://nodemcu-build.com

Enable modules: adc ds18b20 file gpio http mqtt net node ow pwm tmr uart wifi.
Flash float version of firmware.

For uploading files nodemcu-tool can be used https://github.com/AndiDittrich/NodeMCU-Tool

List devices:
$ nodemcu-tool devices

Upload file:
$ nodemcu-tool -p /dev/tty.SLAB_USBtoUART --connection-delay 1000 --baud 9600 upload init.lua

Terminal:
$ nodemcu-tool -p /dev/tty.SLAB_USBtoUART --connection-delay 1000 --baud 9600 terminal

List files:
$ nodemcu-tool -p /dev/tty.SLAB_USBtoUART --connection-delay 1000 --baud 9600 fsinfo

Break timer loop:
$ paste in terminal tmr.stop(0)
