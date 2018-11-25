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
        local df = M.decodeFrame(frame)
        if df then
            mqttHnd.publish("airquality/json", M.convertToJson(df), 0, 0)
            mqttHnd.publish("airquality/env/factory/pm1", df, 0, 0)
            mqttHnd.publish("airquality/env/factory/pm2_5", df, 0, 0)
            mqttHnd.publish("airquality/env/factory/pm10", df, 0, 0)
            mqttHnd.publish("airquality/env/atmospheric/pm1", df, 0, 0)
            mqttHnd.publish("airquality/env/atmospheric/pm2_5", df, 0, 0)
            mqttHnd.publish("airquality/env/atmospheric/pm10", df, 0, 0)
        else
            mqttHnd.publish("airquality/error", getFrameRawString(frame), 0, 0)
        end
    end
end

local function setupUart()
    uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
    uart.alt(1)
    uart.on("data", string.char(0x4d), readFromUart, 0)
end

local function validateFrameEnd(frame)
    if frame[23] == 0x42 and frame[24] == 0x4D then return true else return false end
end

local function calculateCheckSum(frame)
    local sum = 0
    for i=1, 20 do
        sum = sum + frame[i]
    end
    return sum + frame[23] + frame[24]
end

local function decode2byteValue(hByte,lByte)
    return bit.lshift(hByte, 8) + lByte 
end

local function readChecksumFromFrame(frame)
    return decode2byteValue(frame[21],frame[22])
end

local function validateCheckSum(frame)
    local calcCheckSum = calculateCheckSum(frame)
    local readedCheckSum = readChecksumFromFrame(frame)   
    return calcCheckSum == readedCheckSum
end

function M.decodeFrame(frame)
    if validateFrameEnd(frame) and validateCheckSum(frame) then
        return ({
            env = {
                factory = {
                    pm1 = decode2byteValue(frame[3], frame[4]),
                    pm2_5 = decode2byteValue(frame[5], frame[6]),
                    pm10 = decode2byteValue(frame[7], frame[8])
                },
                atmospheric = {
                    pm1 = decode2byteValue(frame[9], frame[10]),
                    pm2_5 = decode2byteValue(frame[11], frame[12]),
                    pm10 = decode2byteValue(frame[13], frame[14])
                }
            }
        })
    else
        return nil
    end
end

function M.convertToJson(decodedFrame)
    return(
    '{' ..
        '"env": {' ..
            '"factory": {' ..
                '"pm1": '   .. decodedFrame.env.factory.pm1 .. ', ' ..
                '"pm2_5": ' .. decodedFrame.env.factory.pm2_5 .. ', ' ..
                '"pm10": '  .. decodedFrame.env.factory.pm10 ..
            '}, ' ..
            '"atmospheric": {' ..
                '"pm1": '   .. decodedFrame.env.atmospheric.pm1 .. ', ' ..
                '"pm2_5": ' .. decodedFrame.env.atmospheric.pm2_5 .. ', ' ..
                '"pm10": '   .. decodedFrame.env.atmospheric.pm10 ..
            '}' ..
        '}' ..
    '}'
    )
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
