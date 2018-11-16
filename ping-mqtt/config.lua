-- conf module
return(
	WIFI = { 
		ssid = "NetworkName", 
		pwd = "Password",
		save = false,
		auto = true
	},
	MQTT = {
		HOST = "192.168.1.2",
		PORT = 1883,
		KEEPALIVE = 120,
		ID = node.chipid(),
		ENDPOINT = "/NodeMCU/",
		DEVPATH = "/NodeMCU/" .. node.chipid()
	},
	PING = {
		PUBDELAY = 10000,
		PINGMSG = "Ping Test!!!"
	}
)
