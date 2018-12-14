log = require("mod_log")
log.setLevel("info") --levels: error, info, debug

log.info("\n=== airquality-pmsx ===")

local config = require("config")
local wifiHandler = require("mod_wifi_handler")
local mqttHandler = require("mod_mqtt_handler")
local pmsxSensor = require("mod_pmsx_sensor")
local pmsxHandler = require("mod_pmsx_handler")

local startTmr = tmr.create()

local function setup()
    
    mqttHandler.onConnected(function()
        log.info("*** mqtt connected event ***")
        pmsxHandler.start(mqttHandler, pmsxSensor, config.PMSX)
    end)

    mqttHandler.onDisconnected(function()
        log.info("*** mqtt disconnected event ***")
        pmsxHandler.stop()
    end)

    wifiHandler.onConnected(function()
        log.info("*** wifi connected event ***")
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
    pmsxHandler.stop()
end

log.info("\nstarting in 5s, type stop() to break...")
startTmr:alarm(5000, tmr.ALARM_SINGLE, run)

