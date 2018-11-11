local M = {}
local t = nil
local mqttHnd = nil
local pin = nil
local pubTimer = tmr.create()

local function readout(temp)
    if t.sens then
      print("Total number of DS18B20 sensors: ".. #t.sens)
      for i, s in ipairs(t.sens) do
        print(string.format("  sensor #%d address: %s%s",  i, ('%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X'):format(s:byte(1,8)), s:byte(9) == 1 and " (parasite)" or ""))
      end
    end
    for addr, tmp in pairs(temp) do
      print(string.format("Sensor %s: %s C", ('%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X'):format(addr:byte(1,8)), tmp))
    end
end

local function publishTemp()
  print("*** publish temperature event ***")
  t:read_temp(readout, pin, t.C)
end

function M.start(ds18b20lv, mqttHandler, conf)
    t = ds18b20lv
    mqttHnd = mqttHandler
    pin = conf.PIN
    pubTimer:alarm(conf.PUBDELAY, tmr.ALARM_AUTO, publishTemp)
    publishTemp()
end

function M.stop()
  pubTimer:unregister()
end

return M