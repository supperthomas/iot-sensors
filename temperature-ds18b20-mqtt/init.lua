local config = require("config")
local wifiHandler = require("wifi_handler")
local mqttHandler = require("mqtt_handler")
local ds18b20Handler = require("ds18b20_handler")

local startTmr = tmr.create()
local pingTmr = tmr.create()

local function setup()
    ds18b20Handler.initialize(mqttHandler, config.DS18B20.ONEWIREPIN)

    mqttHandler.onConnected(function()
        print("=== MQTT CONNECTED EVENT ===")
        pingTmr:alarm(10000, tmr.ALARM_AUTO, ds18b20Handler.publishTemp)
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
    pingTmr:stop()
    wifiHandler.stop()
    mqttHandler.stop()
end

print("\ntemerature-ds18b20-mqtt")
print("\nstarting in 5s, type stop() to break...")

startTmr:alarm(5000, tmr.ALARM_SINGLE, run)
