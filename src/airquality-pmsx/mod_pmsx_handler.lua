local M = {}
local mqttHnd = nil
local pmsxSen = nil
local pubTimer = tmr.create()
local cfg = {
    ENABLED_PIN = 1,
    PUBDELAY = 120000
}

local function publishFrames(sensorData)
    if (sensorData) then
        mqttHnd.publish("airquality/json", pmsxSen.convertToJson(sensorData), 0, 0)
        mqttHnd.publish("airquality/env/factory/pm1", sensorData.env.factory.pm1, 0, 0)
        mqttHnd.publish("airquality/env/factory/pm2_5", sensorData.env.factory.pm2_5, 0, 0)
        mqttHnd.publish("airquality/env/factory/pm10", sensorData.env.factory.pm10, 0, 0)
        mqttHnd.publish("airquality/env/atmospheric/pm1", sensorData.env.atmospheric.pm1, 0, 0)
        mqttHnd.publish("airquality/env/atmospheric/pm2_5", sensorData.env.atmospheric.pm2_5, 0, 0)
        mqttHnd.publish("airquality/env/atmospheric/pm10", sensorData.env.atmospheric.pm10, 0, 0)
    end
end

local function initLogOverMqtt()
    log.info("redirecting log output to mqtt")
    log.on("info", function(msg) mqttHnd.publish("airquality/log/info", msg, 0, 0) end )
    log.on("error", function(msg) mqttHnd.publish("airquality/log/error", msg, 0, 0) end )
    log.on("debug", function(msg) mqttHnd.publish("airquality/log/debug", msg, 0, 0) end )
    
    log.info("log output redirected to mqtt")
end

local function readAndPublish()
    pmsxSen.stop()
    pmsxSen.read(publishFrames, cfg.ENABLED_PIN)
end

function M.start(mqttHandler, pmsxSensor, sensorConfig)
    mqttHnd = mqttHandler
    pmsxSen = pmsxSensor
    cfg = sensorConfig
    initLogOverMqtt()
    readAndPublish()
    pubTimer:alarm(cfg.PUBDELAY, tmr.ALARM_AUTO, readAndPublish)
end

function M.stop()
    pubTimer:unregister()
    if(pmsxSen) then
        pmsxSen.stop()
    end
end

return M
