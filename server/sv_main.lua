local QBCore = exports['qb-core']:GetCoreObject()
local signs = json.decode(LoadResourceFile(GetCurrentResourceName(), "signs.json"))

-- Net Events
RegisterNetEvent("darrk-signs/server/saveSign", function(item, slot, prop, coords)
    source = source
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    local itemInInventory = Player.Functions.GetItemBySlot(slot)
    if itemInInventory then
        Player.Functions.RemoveItem(item, 1, slot)
        signs[#signs + 1] = {
            owner = Player.PlayerData.citizenid,
            prop = prop,
            coords = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
                w = coords.w
            }
        }

        TriggerClientEvent('darrk-signs/client/updateSigns', -1, signs)
    else
        -- Cheating
        exports['qb-core']:ExploitBan(source, "idk")
        -- lib.print.warn("something wrong!")
    end
end)

-- Callbacks
lib.callback.register("darrk-signs/server/getSigns", function (source)
    return signs
end)

lib.callback.register("darrk-signs/server/removeSign", function (source, index)
    local Player = QBCore.Functions.GetPlayer(source)
    local reval = false
    if signs[index] then
        for i = 1, #Shared.Items do
            local thing = Shared.Items[i]
            if thing.prop == signs[index].prop then
                Player.Functions.AddItem(thing.item, 1)
                break
            end
        end
        table.remove(signs, index)
        TriggerClientEvent('darrk-signs/client/updateSigns', -1, signs)
        reval = true
    end
    return reval
end)

lib.callback.register("darrk-signs/server/updateSignContent", function (source, signIndex, type, text)
    local reval = false
    local sign = signs[signIndex]
    
    if sign then
        sign.content = {
            type = type,
            text = text
        }
        reval = true
        TriggerClientEvent("darrk-signs/client/updateSigns", -1, signs)
    end

    return reval
end)

-- Creating items Loop
for i = 1, #Shared.Items do
    local thing = Shared.Items[i]
    if QBCore.Shared.Items[thing.item].useable then
        QBCore.Functions.CreateUseableItem(thing.item, function(source, item)
            local src = source
            local Player = QBCore.Functions.GetPlayer(src)
            if Player.Functions.GetItemByName(item.name) then
                TriggerClientEvent('darrk-signs/client/setupSign', src, thing.item, thing.prop, item.slot, thing.zPlus)
            end
        end)
    else
        lib.print.warn(("%s is not registerd as a useable items!"):format(thing.item))
    end
end

-- Handlers
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SaveResourceFile(resource, "signs.json", json.encode(signs), -1)
    end
end)