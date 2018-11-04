local config = require("config")
local wifiHandler = require("wifi_handler")
local mqttHandler = require("mqtt_handler") 

local startTmr = tmr.create()
local pingTmr = tmr.create()

local function ping()
    local timestamp = tmr.time()
    print( "ping " .. timestamp)
    mqttHandler.publish("ping", "Hello I'm ESP8266 id=" .. config.MQTT.ID .. " | time = " .. timestamp, 0, 0)
end

local function setup()
    mqttHandler.onConnected(function()
        print("=== MQTT CONNECTED EVENT ===")
        pingTmr:alarm(10000, tmr.ALARM_AUTO, ping)
    end)

    mqttHandler.onDisconnected(function()
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
