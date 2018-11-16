mod_conf = require("config")
mod_main = require("mod_main") 
mod_net = require("mod_net")

function initADC()
    if adc.force_init_mode(adc.INIT_ADC)
    then
        print("Initializing ADC, restarting...")
        node.restart()
        return -- don't bother continuing, the restart is scheduled
    end
end

function run()
    initADC()
    mod_net.connect(mod_main.start)
end

function stop()
    tmr.stop(0)
    tmr.stop(6)
end

print("humidity-mqtt")
print("starting in 5s, type stop() to break...")

tmr.alarm(0, 5000, tmr.ALARM_SINGLE, run)
