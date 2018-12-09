local M = {}
local mqttHnd = nil
local pmsxHnd = nil
local pubTimer = tmr.create()
local cfg = {
    PUBDELAY = 10000
}

local function publishFrames(sensorData)
    if decodedFrame then
        mqttHnd.publish("airquality/rawframe", pmsxHnd.getFrameRawString(sensorData.raw), 0, 0)
        mqttHnd.publish("airquality/json", pmsxHnd.convertToJson(sensorData.decoded), 0, 0)
        mqttHnd.publish("airquality/env/factory/pm1", sensorData.decoded.env.factory.pm1, 0, 0)
        mqttHnd.publish("airquality/env/factory/pm2_5", sensorData.decoded.env.factory.pm2_5, 0, 0)
        mqttHnd.publish("airquality/env/factory/pm10", sensorData.decoded.env.factory.pm10, 0, 0)
        mqttHnd.publish("airquality/env/atmospheric/pm1", sensorData.decoded.env.atmospheric.pm1, 0, 0)
        mqttHnd.publish("airquality/env/atmospheric/pm2_5", sensorData.decoded.env.atmospheric.pm2_5, 0, 0)
        mqttHnd.publish("airquality/env/atmospheric/pm10", sensorData.decoded.env.atmospheric.pm10, 0, 0)
    else
        mqttHnd.publish("airquality/error/rawframe", pmsxHnd.getFrameRawString(sensorData.raw), 0, 0)
    end
end

function M.start(mqttHandler, pmsxHandler, sensorConfig)
    mqttHnd = mqttHandler
    pmsxHnd = pmsxHandler
    cfg = sensorConfig
    pmsxHnd.read(publishFrames)
end

function M.stop()
    pubTimer:unregister()
    pmsxHnd.stop()
end

return M
