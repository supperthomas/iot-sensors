log = require("log")
log.setLevel("debug") --levels: error, info, debug

log.info("\n=== airquality-pmsx ===")

local config = require("config")
local wifiHandler = require("mod_handler_wifi")
local mqttHandler = require("mod_handler_mqtt")
local pmsxSensor = require("mod_sensor_pmsx")
local pmsxHandler = require("mod_handler_pmsx")

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

