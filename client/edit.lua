CreateThread(function()
    if Config.Framework == "ESX" then
        ESX = exports.es_extended:getSharedObject()
    end
end)


Notify = function(title, message, type, duration)
    if Config.Notify == "ox_lib" then
        lib.notify({
            title = title,
            description = message,
            type = type,
            duration = duration
        })
    end
end

ProgressBar = function(message, duration)
    if Config.ProgressBar == "ox_lib" then
        return lib.progressBar({
            duration = duration,
            label = message,
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true
            }
        })
    end
end

Minigame = function()
    local success = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
    return success
end