print("\n=== humidity-syhs200-mqtt ===")

local config = require("config")
local wifiHandler = require("mod_wifi")
local mqttHandler = require("mod_mqtt")
local syhs220Handler = require("mod_syhs220_mqtt")

local startTmr = tmr.create()

local function setup()
    syhs220Handler.initialize()
    
    mqttHandler.onConnected(function()
        print("*** mqtt connected event ***")
        syhs220Handler.start(mqttHandler, config.SYHS220)
    end)

    mqttHandler.onDisconnected(function()
        print("*** mqtt disconnected event ***")
        syhs220Handler.stop()
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
    syhs220Handler.stop()
end

print("\nstarting in 5s, type stop() to break...")
startTmr:alarm(5000, tmr.ALARM_SINGLE, run)

