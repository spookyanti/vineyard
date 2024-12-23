AddItem = function(source, item, amount)
    if Config.Inventory == "ox_inventory" then
        print(source, item, amount)
        exports.ox_inventory:AddItem(source, item, amount)
    end
end

HasItem = function(source, item, amount)
    if Config.Inventory == "ox_inventory" then
        local item = exports.ox_inventory:Search(source, "count", item)
        if item >= amount then
            return true
        else
            return false
        end
    end
end

RemoveItem = function(source, item, amount)
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:RemoveItem(source, item, amount)
    end
end