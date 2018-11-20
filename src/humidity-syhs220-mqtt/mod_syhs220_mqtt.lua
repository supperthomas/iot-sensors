local M = {}
local mqttHnd = nil
local pubTimer = tmr.create()
local cfg = {
    PUBDELAY = 10000
}

local function initADC()
    if adc.force_init_mode(adc.INIT_ADC)
    then
        print("Initializing ADC, restarting...")
        node.restart()
    end
end

local function publishHumidity()
    print("*** publish humidity syhs220 event ***")

	local radc = adc.read(0)
	local v = 2.0*radc/666.0
	local h = v*50.0/1.650

    print("adc: " .. radc)
	print("adc/volt: " .. v)
	print("adc/humidity: " .. h)
    
	mqttHnd.publish("adc", radc ,0,0)
	mqttHnd.publish("adc/volt", v ,0,0)
	mqttHnd.publish("adc/humidity", h ,0,0)
end

function M.initialize()
    initADC()
end

function M.start(mqttHandler, sensorConfig)
    mqttHnd = mqttHandler
    cfg = sensorConfig
    pubTimer:alarm(cfg.PUBDELAY, tmr.ALARM_AUTO, publishHumidity)
    publishHumidity()
end

function M.stop()
    pubTimer:unregister()
end

return M