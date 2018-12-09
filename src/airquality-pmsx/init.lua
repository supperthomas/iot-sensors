print("\n=== airquality-pmsx ===")

local config = require("config")
local wifiHandler = require("mod_wifi")
local mqttHandler = require("mod_mqtt")
local pmsxHandler = require("mod_pmsx")
local pmsxMqttHandler = require("mod_pmsx_mqtt")

local startTmr = tmr.create()

local function setup()
    
    mqttHandler.onConnected(function()
        print("*** mqtt connected event ***")
        pmsxMqttHandler.start(mqttHandler, pmsxHandler, config.PMSX)
    end)

    mqttHandler.onDisconnected(function()
        print("*** mqtt disconnected event ***")
        pmsxMqttHandler.stop()
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
    pmsxMqttHandler.stop()
end

print("\nstarting in 5s, type stop() to break...")
startTmr:alarm(5000, tmr.ALARM_SINGLE, run)

