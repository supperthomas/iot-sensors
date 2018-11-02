-- main module

local M = {}
local m = nil

local function mqtt_publish()
	print(mod_conf.MQTT.DEVPATH .. "/ping" .. " | " .. "Hello I'm ESP8966 | time = " .. tmr.time())
	m:publish( mod_conf.MQTT.DEVPATH .. "/ping", "Hello I'm ESP8966 id=" .. mod_conf.MQTT.ID .. " | time = " .. tmr.time() ,0,0)
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
