# IoT NodeMCU scripts for ESP8266

## Prepare ESP8266
Use custom build of NodeMCU (https://nodemcu-build.com).

Enable modules: adc ds18b20 file gpio http mqtt net node ow pwm tmr uart wifi.

Flash float version of firmware (https://nodemcu.readthedocs.io/en/latest/en/flash).

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

For uploading **nodemcu-tool** can be used (https://github.com/AndiDittrich/NodeMCU-Tool).

List devices:
```
$ nodemcu-tool devices
```

Upload files:
```
$ nodemcu-tool -p /dev/tty.usbserial-1420 --connection-delay 1000 --baud 9600 upload *.lua
```

List files:
```
$ nodemcu-tool -p /dev/tty.usbserial-1420 --connection-delay 1000 --baud 9600 fsinfo
```

## Running scripts

Scripts will be executed automatically after restart.

Connect terminal to display output:

```
$ nodemcu-tool -p /dev/tty.usbserial-1420 --connection-delay 1000 --baud 9600 terminal

[terminal]    ~ Starting Terminal Mode - press ctrl+c to exit 

NodeMCU 0.9.6 build 20150704  powered by Lua 5.1.4
humidity-mqtt
starting in 5s, type stop() to break...
> Trying connect to krypta13:
.
.
IP Address: 	192.168.1.236	
Netmask: 	255.255.255.0	
Gateway: 	192.168.1.1
Connecting to MQTT broker 192.168.1.2:1883 as 16397639:
Connected to MQTT broker!
```

To interrupt script type in terminal:
```
tmr(0).stop()
```
