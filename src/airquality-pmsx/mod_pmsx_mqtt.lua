local M = {}
local mqttHnd = nil
local pubTimer = tmr.create()
local cfg = {
    PUBDELAY = 10000
}

local function publishAirQuality()
	-- mqttHnd.publish("adc", radc ,0,0)
	-- mqttHnd.publish("adc/volt", v ,0,0)
	-- mqttHnd.publish("adc/humidity", h ,0,0)
end

local function getFrameRawString(frame)
    local frameString = ""
    for i=1, table.getn(frame) do
        frameString = frameString .. ("%X "):format(frame[i])
    end
    return frameString
end


local function readFromUart(data)
    local len = data:len()
    if len >= 24 then    
        local frame = { data:byte(len-23,len) }
        mqttHnd.publish("airquality/rawframe", getFrameRawString(frame), 0, 0)
    end
end

local function setupUart()
    uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
    uart.alt(1)
    mqttHnd.publish("airquality/beforeuarton", 1, 0, 0)
    uart.on("data", string.char(0x4d), readFromUart, 0)
    mqttHnd.publish("airquality/ready", 1, 0, 0)
end



function M.start(mqttHandler, sensorConfig)
    mqttHnd = mqttHandler
    cfg = sensorConfig
    setupUart()
    --pubTimer:alarm(cfg.PUBDELAY, tmr.ALARM_AUTO, publishAirQuality)
    --publishAirQuality()
end

function M.stop()
    pubTimer:unregister()
end

return M
