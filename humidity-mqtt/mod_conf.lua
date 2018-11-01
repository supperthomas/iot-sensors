-- conf module

local M = {}

M.WIFI = { 
	SSID = "StationName", 
	PASSWORD = "Pass" 
}

M.MQTT = {
	HOST = "192.168.1.2",
	PORT = 1883,
	KEEPALIVE = 120,
	ID = node.chipid(),
	ENDPOINT = "/NodeMCU/",
	DEVPATH = "/NodeMCU/" .. node.chipid()
	
}

return M
