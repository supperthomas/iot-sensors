local config = require("config")
local ds18b20lv = require("mod_ds18b20")
local temperatureHandler = require("mod_temerature")
local wifiHandler = require("mod_wifi")
local mqttHandler = require("mod_mqtt")

local startTmr = tmr.create()

local function setup()
    temperatureHandler.initialize(ds18b20lv, config.ONEWIRE.PIN)

    mqttHandler.onConnected(function()
        print("=== MQTT CONNECTED EVENT ===")
        pingTmr:alarm(10000, tmr.ALARM_AUTO, temperatureHandler.publishTemp)
    end)

    mqttHandler.onDisconnected(function()
        print("=== MQTT DISCONNECTED EVENT ===")
        pingTmr:unregister()
    end)

    wifiHandler.onConnected(function()
        print("=== WIFI CONNECTED EVENT ===")
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
end

print("\ntemerature-ds18b20-mqtt")
print("\nstarting in 5s, type stop() to break...")
startTmr:alarm(5000, tmr.ALARM_SINGLE, run)

--temperatureHandler.initialize(ds18b20lv, config.ONEWIRE.PIN)
--temperatureHandler.publishTemp()
