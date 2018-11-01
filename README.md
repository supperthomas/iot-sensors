# IoT scripts for ESP8266 flashed with NodeMCU

## Prepare ESP8266
Use custom build of NodeMCU https://nodemcu-build.com

Enable modules: adc ds18b20 file gpio http mqtt net node ow pwm tmr uart wifi.

Flash float version of firmware https://nodemcu.readthedocs.io/en/latest/en/flash

Example of flashing command for  ESP8266 ESP-12 (>=4 MByte modules):
```
esptool.py --port /dev/tty.usbserial-1420 write_flash -fm dio 0x00000 nodemcu-float.bin 
```

## Config

Each subdirectory contains self-sufficient set of scripts which should be uploaded to device.

1. humidity-mqtt: periodically read value from humidity sensor (SY-HS-200) and publish it to mqtt message broker.
2. ping-mqtt: periodically publish (ping) to mqtt message broker.

Edit **mod_conf.lua** and setup network.


## Upload scripts

For uploading files **nodemcu-tool** can be used https://github.com/AndiDittrich/NodeMCU-Tool

List devices:
```
$ nodemcu-tool devices
```

Upload file:
```
$ nodemcu-tool -p /dev/tty.usbserial-1420 --connection-delay 1000 --baud 9600 upload *.lua
```

Terminal:
```
$ nodemcu-tool -p /dev/tty.usbserial-1420 --connection-delay 1000 --baud 9600 terminal
```

List files:
```
$ nodemcu-tool -p /dev/tty.usbserial-1420 --connection-delay 1000 --baud 9600 fsinfo
```

