-- main module

local M = {}
local m = nil

local function subscribe()
	m:subscribe( mod_conf.MQTT.DEVPATH .. "/GPIO0/write",0,function(conn)
		print("Subscribed to " .. mod_conf.MQTT.DEVPATH .. "/GPIO0/write")
    end)

end

local function mqtt_publish()
	local radc = adc.read(0)
	local v = 2.0*radc/666.0
	local h = v*50.0/1.650

	--print( mod_conf.MQTT.DEVPATH .. "/adc: " .. radc)
	--print( mod_conf.MQTT.DEVPATH .. "/adc/volt: " .. v)
	--print( mod_conf.MQTT.DEVPATH .. "/adc/humidity: " .. h)

	m:publish( mod_conf.MQTT.DEVPATH .. "/adc", radc ,0,0)
	m:publish( mod_conf.MQTT.DEVPATH .. "/adc/volt", v ,0,0)
	m:publish( mod_conf.MQTT.DEVPATH .. "/adc/humidity", h ,0,0)
end

local function mqtt_connect()
	print("Connecting to MQTT broker " .. mod_conf.MQTT.HOST .. ":" .. mod_conf.MQTT.PORT .. " as " .. mod_conf.MQTT.ID .. ":")
	m:close()
	tmr.stop(6)
	
	if(wifi.sta.status() ~= 5) then
		print("Network connection broken, restarting...")
		node.restart()
	end
	
	tmr.alarm(6, 20000, tmr.ALARM_SINGLE, function()
		print("MQTT connection timeout!")
		mqtt_connect()
	end)
	
	m:connect(mod_conf.MQTT.HOST, mod_conf.MQTT.PORT, 0, function(conn)
	 	tmr.stop(6)
		tmr.alarm(6, 10000, tmr.ALARM_AUTO, mqtt_publish)
		print("Connected to MQTT broker!")
	end)	
end

local function init_mqtt(run_when_connected) 
	m = mqtt.Client(mod_conf.MQTT.ID, mod_conf.MQTT.KEEPALIVE)
	
	m:on("message", function(conn, topic, data) 
      if data ~= nil then
        print(topic .. ": " .. data)
        -- do something, we have received a message
      end
    end)
	
	m:on("offline", function(conn, topic, data)
		print("Offline!")
		mqtt_connect()
	end)
	
	mqtt_connect()

end

function M.start()
	init_mqtt()
end

return M
