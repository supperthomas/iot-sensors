local M = {}
local mqttHnd = nil
local pmsxHnd = nil
local pubTimer = tmr.create()
local cfg = {
    PUBDELAY = 10000
}



local function publishFrames(sensorData)
    if (sensorData) then
        mqttHnd.publish("airquality/json", pmsxHnd.convertToJson(sensorData), 0, 0)
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

function M.start(mqttHandler, pmsxHandler, sensorConfig)
    mqttHnd = mqttHandler
    pmsxHnd = pmsxHandler
    cfg = sensorConfig
    initLogOverMqtt()
    pmsxHnd.read(publishFrames)
end

function M.stop()
    pubTimer:unregister()
    if(pmsxHnd) then
        pmsxHnd.stop()
    end
end

return M
