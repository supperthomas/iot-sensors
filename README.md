# IoT Sensors for NodeMCU / ESP8266

Each subdirectory of **[/src](src)** represent independent feature(s):
1. [airquality-pmsx](src/airquality-pmsx): periodically read values from Plantower PMS3003 Air Quality sensor and publish to mqtt message broker.
1. [humidity-syhs220](src/humidity-syhs220): periodically read value from humidity sensor SY-HS-220 and publish it to mqtt message broker.
2. [ping](src/ping-mqtt): periodically publish (ping) to mqtt message broker.
3. [temperature-ds18b20](src/temperature-ds18b20): periodically read temperature from 1-Wire DS18B20 thermometer and publish to mqtt message broker.

## Setup
Scripts in each subdirectory are sef-sufficient. To make thing working:
1. Edit **config.lua** and setup network
2. Upload all files from particular directory to NodeMCU device.

## Prepare ESP8266
Use custom [NodeMCU build](https://nodemcu-build.com).

* Enable modules: adc bit file gpio http mqtt net node ow pwm tmr uart wifi tls/ssl.
* Flash float version of firmware. 

Example of using esptool for flashing ESP8266 ESP-12 (>=4 MByte modules):
```
esptool.py --port /dev/tty.usbserial-1420 write_flash -fm dio 0x00000 nodemcu-float.bin 
```

For detailed flashing instructions and tools check [NodeMCU documentation](https://nodemcu.readthedocs.io/en/latest/en/flash).

## Upload scripts

For uploading [nodemcu-tool](https://github.com/AndiDittrich/NodeMCU-Tool) can be used.

List devices:
```
$ nodemcu-tool devices
```

Upload files:
```
$ nodemcu-tool -p /dev/tty.usbserial-1420 --connection-delay 1000 upload *.lua
```

List files:
```
$ nodemcu-tool -p /dev/tty.usbserial-1420 --connection-delay 1000 fsinfo
```

Sometimes it is required to explicitly set baud rate in each command:
```
$ nodemcu-tool -p /dev/tty.usbserial-1420 --connection-delay 1000 --baud 9600 fsinfo
```

## Running scripts

Scripts will be executed automatically after restart.

Connect terminal to display output:

```
$ nodemcu-tool -p /dev/tty.usbserial-1420 --connection-delay 1000 terminal

[terminal]    ~ Starting Terminal Mode - press ctrl+c to exit 

NodeMCU custom build by frightanic.com
        branch: master
        commit: c708828bbe853764b9de58fb8113a70f5a24002d
        SSL: true
        modules: adc,bit,file,gpio,http,mqtt,net,node,ow,pwm,tmr,uart,wifi,tls
 build created on 2018-11-01 13:06
 powered by Lua 5.1.4 on SDK 2.2.1(6ab97e9)

humidity-mqtt
starting in 5s, type stop() to break...
> Trying connect to krypta13:
.
.
.
.
IP Address:     192.168.1.134
Netmask:        255.255.255.0
Gateway:        192.168.1.1
Connecting to MQTT broker 192.168.1.2:1883 as 13974697:
Connected to MQTT broker!
```

Reupload files only when script is not running.
To stop script type in terminal:
```
stop()
```
