# IoT scripts for ESP8266 flashed with NodeMCU.

## Prepare ESP8266
Use custom build of NodeMCU https://nodemcu-build.com

Enable modules: adc ds18b20 file gpio http mqtt net node ow pwm tmr uart wifi.
Flash float version of firmware https://nodemcu.readthedocs.io/en/latest/en/flash

Example flashing command for  ESP8266 ESP-12 (>=4 MByte modules):
```
esptool.py --port /dev/tty.usbserial-1420 write_flash -fm dio 0x00000 nodemcu-float.bin 
```

## Upload scripts

For uploading files **nodemcu-tool** can be used https://github.com/AndiDittrich/NodeMCU-Tool

List devices:
$ nodemcu-tool devices

Upload file:
```
$ nodemcu-tool -p /dev/tty.usbserial-1420 --connection-delay 1000 --baud 9600 upload init.lua
```

Terminal:
```
$ nodemcu-tool -p /dev/tty.usbserial-1420 --connection-delay 1000 --baud 9600 terminal
```

List files:
```
$ nodemcu-tool -p /dev/tty.usbserial-1420 --connection-delay 1000 --baud 9600 fsinfo
```

Break timer loop:
```
$ paste in terminal tmr.stop(0)
```
