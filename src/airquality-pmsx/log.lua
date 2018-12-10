local M = {}

local lvl = 3
local onError = function(msg) print(tmr.time() .. " <error> " .. msg) end
local onInfo = function(msg) print(msg) end
local onDebug = function(msg) print(tmr.time() .. " <debug> " .. msg) end

function M.setLevel(level)
    if(level == "error") then lvl = 1
    elseif (level == "info") then lvl = 2
    elseif(level == "debug") then lvl = 3
    end
end

function M.error(msg) 
    if(lvl >= 1) then onError(msg) end
end

function M.info(msg) 
    if(lvl >= 2) then onInfo(msg) end
end

function M.debug(msg) 
    if(lvl >= 3) then onDebug(msg) end
end

function M.on(event, fn)
    if(event == "error") then onError = fn
    elseif (event == "info") then onInfo = fn
    elseif(event == "debug") then onDebug = fn
    end
end

return M