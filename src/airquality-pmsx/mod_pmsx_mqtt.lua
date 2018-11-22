local M = {}
local mqttHnd = nil
local pubTimer = tmr.create()
local cfg = {
    PUBDELAY = 10000
}

local function publishAirQuality()
    print("*** publish air quality pmsx event ***")
	-- mqttHnd.publish("adc", radc ,0,0)
	-- mqttHnd.publish("adc/volt", v ,0,0)
	-- mqttHnd.publish("adc/humidity", h ,0,0)
end

function M.start(mqttHandler, sensorConfig)
    mqttHnd = mqttHandler
    cfg = sensorConfig
    pubTimer:alarm(cfg.PUBDELAY, tmr.ALARM_AUTO, publishAirQuality)
    publishAirQuality()
end

function M.stop()
    pubTimer:unregister()
end

return M
