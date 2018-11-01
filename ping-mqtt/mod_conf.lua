-- conf module

local M = {}

M.WIFI = { 
	SSID = "NetworkName", 
	PASSWORD = "Pass" 
}

M.MQTT = {
	HOST = "192.168.17.2",
	PORT = 1883,
	KEEPALIVE = 120,
	ID = node.chipid(),
	ENDPOINT = "/NodeMCU/",
	DEVPATH = "/NodeMCU/" .. node.chipid()
	
}

return M
