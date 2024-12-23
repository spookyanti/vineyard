

lib.callback.register('spf_vineyard:addItem', function(source, item, amount, td)
    local targetPos = td.coords
    print(targetPos)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    local distance = #(playerCoords - targetPos)
    if distance >= 5 then
        print("cheater")
    else
        AddItem(source, item, amount)
    end
end)


lib.callback.register('spf_vineyard:hasItem', function(source, item, amount)
    local hasItem = HasItem(source, item, amount)
    return hasItem
end)

lib.callback.register('spf_vineyard:removeItem', function(source, item, amount)
    RemoveItem(source, item, amount)
    return 
end)