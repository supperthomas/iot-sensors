local M = {}
local mqttHnd = nil
local pubTimer = tmr.create()
local cfg = {
    PUBDELAY = 10000,
    PINGMSG = "ping msg"
}

local function publishPing()
    print("*** publish ping event ***")
    local msg = cfg.PINGMSG .. " time = " .. tmr.time()
    print(msg)
    mqttHnd.publish("ping", msg, 0, 0)
end

function M.start(mqttHandler, pingConfig)
    mqttHnd = mqttHandler
    cfg = pingConfig
    pubTimer:alarm(cfg.PUBDELAY, tmr.ALARM_AUTO, publishPing)
    publishPing()
end

function M.stop()
    pubTimer:unregister()
end

return M
