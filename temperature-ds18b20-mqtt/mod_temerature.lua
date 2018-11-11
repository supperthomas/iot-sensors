local M = {}
local t = nil
local pin = 3 -- gpio0 = 3, gpio2 = 4

local function readout(temp)
    if t.sens then
      print("Total number of DS18B20 sensors: ".. #t.sens)
      for i, s in ipairs(t.sens) do
        print(string.format("  sensor #%d address: %s%s",  i, ('%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X'):format(s:byte(1,8)), s:byte(9) == 1 and " (parasite)" or ""))
      end
    end
    for addr, temp in pairs(temp) do
      print(string.format("Sensor %s: %s °C", ('%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X'):format(addr:byte(1,8)), temp))
    end
end

function M.initialize(ds18b20lv, owPin)
    t = ds18b20lv
    pin = owPin
end

function M.publishTemp()
    print("=== PUBLISH DS18B20 TEMPERATURE EVENT ===")
    t:read_temp(readout, pin, t.C)
end

return M