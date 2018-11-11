print("\n=== temperature-ds18b20 ===")

local config = require("config")
local ds18b20lv = require("mod_ds18b20")
local tempMqttHandler = require("mod_ds18b20_mqtt")
local wifiHandler = require("mod_wifi")
local mqttHandler = require("mod_mqtt")
local startTmr = tmr.create()

local function setup()
    mqttHandler.onConnected(function()
        print("*** mqtt connected event ***")
        tempMqttHandler.start(ds18b20lv, mqttHandler, config.DS18B20)
    end)

    mqttHandler.onDisconnected(function()
        print("*** mqtt disconnected event ***")
        pingTmr:unregister()
    end)

    wifiHandler.onConnected(function()
        print("*** wifi connected event ***")
        mqttHandler.connect(config.MQTT)
    end)
end

local function run()
    setup()
    wifiHandler.connect(config.WIFI)
end

function stop()
    startTmr:stop()
    wifiHandler.stop()
    mqttHandler.stop()
    tempMqttHandler.stop()
end

print("\nstarting in 5s, type stop() to break...")
startTmr:alarm(5000, tmr.ALARM_SINGLE, run)

