--net module

local M = {}
local conTmr = tmr.create()
local connectedCbk = nil

function M.onConnected(connectedCallback)
	connectedCbk = connectedCallback
end

function M.stop()
	conTmr:unregister()
end

function M.connect(wifiConfig)
	wifi.setmode(wifi.STATION)
	tmr.delay(1000)
	local it = 0
	wifi.sta.config(wifiConfig)
	print("Trying connect to " .. wifiConfig.ssid .. ":")
	conTmr:alarm(1000, tmr.ALARM_AUTO, function()   
		it=it+1
		ip, nm, gw=wifi.sta.getip()
		if ip ~= nil then
			conTmr:unregister()         
			print("IP Address: ",ip,"\nNetmask: ",nm,"\nGateway: ",gw)         
			
			if connectedCbk ~= nil then
				connectedCbk();
			end
			return
		end
		if it >= 180 then
			print("Unable connect to network, restarting...")
			node.restart()
		end
		print(".")
	end )
end

return M
