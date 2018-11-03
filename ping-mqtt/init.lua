mod_conf = require("mod_conf")
mod_main = require("mod_main") 
mod_net = require("mod_net")

function run()
    mod_net.connect(mod_main.start)
end

function stop()
    tmr.stop(0)
    tmr.stop(6)
end

print("ping-mqtt")
print("starting in 5s, type stop() to break...")

tmr.alarm(0, 5000, tmr.ALARM_SINGLE, run)
