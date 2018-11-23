--setup
tmr = {
    create = function() 
        return({
            unregister = function(self) end
        })
    end
}

local GOOD_FRAMES =
{
    "0 14 0 74 0 C5 0 DE 0 4C 0 82 0 94 17 15 0 93 91 0 5 6C 42 4D",
    "0 14 0 73 0 C2 0 E1 0 4C 0 81 0 96 17 8 0 9A 91 0 5 66 42 4D",
    "0 14 0 73 0 C0 0 D9 0 4C 0 7F 0 8F 16 EB 0 8D 91 0 6 28 42 4D",
    "0 14 0 74 0 C0 0 D9 0 4C 0 7F 0 90 16 EB 0 8D 91 0 6 2A 42 4D",
    "0 14 0 74 0 BF 0 DB 0 4C 0 7F 0 92 16 B2 0 96 91 0 5 FD 42 4D",
    "0 14 0 73 0 BF 0 DB 0 4C 0 7F 0 91 16 B2 0 96 91 0 5 FB 42 4D",
    "0 14 0 72 0 BF 0 E2 0 4B 0 7F 0 96 16 92 0 A7 91 0 5 F6 42 4D",
    "0 14 0 73 0 BF 0 E3 0 4B 0 7F 0 96 16 92 0 A7 91 0 5 F8 42 4D",
    "0 14 0 73 0 BD 0 E1 0 4B 0 7D 0 95 16 75 0 A2 91 0 5 CF 42 4D",
    "0 14 0 72 0 BD 0 E0 0 4B 0 7D 0 95 16 75 0 A2 91 0 5 CD 42 4D",
    "0 14 0 73 0 BF 0 E2 0 4C 0 7F 0 96 16 B8 0 A4 91 0 6 1B 42 4D",
    "0 14 0 72 0 BF 0 E5 0 4B 0 7F 0 98 16 8C 0 A2 91 0 5 F0 42 4D"
}

local BAD_FRAMES =
{
   
}

local function frameHexStringToArray(frameHexString)
    local o = {}
    local i = 1
    for v in string.gmatch(frameHexString, "%S+") do
        o[i] = tonumber("0x" .. v)
        i=i+1
    end
    return o
end

local function printFrame(frame)
    local outStr = ""
    for i=1, 24 do 
        outStr = outStr .. " " .. frame[i]
    end
    print(outStr)
end

local sut = dofile("../mod_pmsx_mqtt.lua")

function test_Given_frame_When_notends_with_0x42_0x4D_then_return_nil()
    local frame1 = frameHexStringToArray(GOOD_FRAMES[1])
    local frame2 = frameHexStringToArray(GOOD_FRAMES[2])

    frame1[24] = 0x41
    frame2[23] = 0x1 
    
    if sut.decodeFrame(frame1) then error() end
    if sut.decodeFrame(frame2) then error() end
end

test_Given_frame_When_notends_with_0x42_0x4D_then_return_nil()

