local M = {}
local mqttHnd = nil
local pubTimer = tmr.create()
local cfg = {
    PUBDELAY = 10000,
    PINGMSG = "Ping Test!"
}

local function publishPing
    local msg = cfg.PINGMSG .. " time = " .. tmr.time()
    mqttHnd.publish("ping", msg, 0, 0)
end

function M.start(mqttHandler, pingConfig)
    mqttHnd = mqttHandler
    cfg = pingConfig
    pubTimer:alarm(cfg.PUBDELAY, tmr.ALARM_AUTO, publishPing)
    publishTemp()
end

function M.stop()
    pubTimer:unregister()
end

return M
