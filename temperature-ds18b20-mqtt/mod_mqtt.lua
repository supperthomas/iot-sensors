-- main module

local M = {}
local m = nil
local cfg = nil
local conTmr = tmr.create()
local connectedCbk = nil
local disconnectedCbk = nil

local function mqttConnect()
	print("Connecting to MQTT broker " .. cfg.HOST .. ":" .. cfg.PORT .. " as " .. cfg.ID .. ":")
	m:close()
	conTmr:unregister()
	
	if(wifi.sta.status() ~= 5) then
		print("Network connection broken, restarting...")
		node.restart()
	end
	
	conTmr:alarm(20000, tmr.ALARM_SINGLE, function()
		print("MQTT connection timeout!")
		mqttConnect()
	end)
	
	m:connect(cfg.HOST, cfg.PORT, 0, function(conn)
		conTmr:unregister()
		print("Connected to MQTT broker!")
		if connectedCbk ~= nil then connectedCbk() end
	end)	
end

function M.onConnected(connectedCallback)
	connectedCbk = connectedCallback
end

function M.onDisconnected(disconnectedCallback)
	disconnectedCbk = disconnectedCallback
end

function M.connect(mqttConfig) 
	cfg = mqttConfig
	m = mqtt.Client(cfg.ID, cfg.KEEPALIVE)
	
	m:on("message", function(conn, topic, data) 
      if data ~= nil then
        print(topic .. ": " .. data)
        -- do something, we have received a message
      end
    end)
	
	m:on("offline", function(conn, topic, data)
		print("MQTT Offline!")
		if disconnectedCbk ~= nil then disconnectedCbk() end
		mqttConnect()
	end)
	
	mqttConnect()
end

function M.stop()
	conTmr:unregister()
end

function M.publish(topic, payload, qos, retain)
	m:publish(cfg.DEVPATH .. "/" .. topic, payload, qos, retain)
end

return M
