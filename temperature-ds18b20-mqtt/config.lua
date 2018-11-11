-- conf module

local M = {}

M.WIFI = { 
	ssid = "NetworkName", 
	pwd = "Pass",
	save = false,
	auto = true
}

M.MQTT = {
	HOST = "192.168.1.2",
	PORT = 1883,
	KEEPALIVE = 120,
	ID = node.chipid(),
	ENDPOINT = "/NodeMCU/",
	DEVPATH = "/NodeMCU/" .. node.chipid()
}

M.ONEWIRE = {
	PIN = 3 -- gpio0 = 3, gpio2 = 4
}
return M
