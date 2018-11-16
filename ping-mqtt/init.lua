print("\n=== ping-mqtt ===")

local config = require("config")
local wifiHandler = require("mod_wifi")
local mqttHandler = require("mod_mqtt")
local pingHandler = require("mod_ping_mqtt")

local startTmr = tmr.create()

local function setup()
    mqttHandler.onConnected(function()
        print("*** mqtt connected event ***")
        pingHandler.start(mqttHandler, config.PING)
    end)

    mqttHandler.onDisconnected(function()
        print("*** mqtt disconnected event ***")
        pingHandler.stop()
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
    pingHandler.stop()
end

print("\nstarting in 5s, type stop() to break...")
startTmr:alarm(5000, tmr.ALARM_SINGLE, run)

