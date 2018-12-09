local M = {}
local onReadCbk = nil

local publishNthFrame=100
local frameCount=90

local function setupUart()
    uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
    uart.alt(1)
    uart.on("data", string.char(0x4d), readFromUart, 0)
end

local function readFromUart(data)
    frameCount = frameCount + 1
    if frameCount < publishNthFrame then return end
    frameCount = 1

    local len = data:len()
    if len >= 24 then    
        local frame = createFrame(data)
        local decodedFrame = M.decodeFrame(frame)
        local sensorData = {
            raw = frame,
            decoded = decodedFrame
        }
        onReadCallback(sensorData)
    end
end

local function createFrame(data)
    local frame = { data:byte(len-23,len-2) }
    table.insert(frame, 1, dataTest:byte(len-1))
    table.insert(frame, 2, dataTest:byte(len))
    return frame
end

local function validateFrameStart(frame)
    if frame[1] == 0x42 and frame[2] == 0x4D then return true else return false end
end

local function decode2byteValue(hByte,lByte)
    return bit.lshift(hByte, 8) + lByte 
end

local function calculateCheckSum(frame)
    local sum = 0
    for i=1, 22 do
        sum = sum + frame[i]
    end
    return sum
end

local function readChecksumFromFrame(frame)
    return decode2byteValue(frame[23],frame[24])
end

local function validateCheckSum(frame)
    local calcCheckSum = calculateCheckSum(frame)
    local readedCheckSum = readChecksumFromFrame(frame)   
    return calcCheckSum == readedCheckSum
end

function M.read(onReadCallback)
    onReadCbk = onReadCallback
    setupUart()
end

function M.stop()
    uart.on("data")
end

function M.decodeFrame(frame)
    if validateFrameStart(frame) and validateCheckSum(frame) then
        return ({
            env = {
                factory = {
                    pm1 = decode2byteValue(frame[5], frame[6]),
                    pm2_5 = decode2byteValue(frame[7], frame[8]),
                    pm10 = decode2byteValue(frame[9], frame[10])
                },
                atmospheric = {
                    pm1 = decode2byteValue(frame[11], frame[12]),
                    pm2_5 = decode2byteValue(frame[13], frame[14]),
                    pm10 = decode2byteValue(frame[15], frame[16])
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

function M.getFrameRawString(frame)
    local frameString = ""
    for i=1, table.getn(frame) do
        frameString = frameString .. ("%X "):format(frame[i])
    end
    return frameString
end

return M
