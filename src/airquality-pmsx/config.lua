-- conf module
return({
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
	PMSX = {
		ENABLED_PIN = 1, --IO index= 0:GPIO16, 1:GPIO5, 2:GPIO4, 3:GPIO0, 4:GPIO2, 5:GPIO14, 6:GPIO12, 7:GPIO13, 8:GPIO15, 9:GPIO3, 10:GPIO1, 11:GPIO9, 12:GPIO10
		PUBDELAY = 60000
	}
})
