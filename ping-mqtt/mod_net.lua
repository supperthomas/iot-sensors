--net module

local M = {}
local it = 0;
function M.connect(run_when_connected)
	wifi.setmode(wifi.STATION)
	tmr.delay(1000)
	it = 0
	wifi.sta.config(mod_conf.WIFI)
	print("Trying connect to " .. mod_conf.WIFI.ssid .. ":")
	tmr.alarm(0, 1000, tmr.ALARM_AUTO, function()   
		it=it+1
		ip, nm, gw=wifi.sta.getip()
		if ip ~= nil then         
			print("IP Address: ",ip,"\nNetmask: ",nm,"\nGateway: ",gw)         
			tmr.stop(0)
			run_when_connected()
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
